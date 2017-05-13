defmodule Ctrl.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.
              ,---------.
              v         |
             Idle ----->|
      :resume |         |
              v         |
        ,-> Resting --->|
        |     | dT>0.1  |
        |     v         |
        |   Heating --->|
        |     | dt=0    |
        |     v         |
        |   Slacking ---' :pause
        |     | dT<0.05
        `-----'

  * `dT` is delta in temperature over a sliding window of _n_ samples
  * `dt` is the time the heater should be heating.
  """

  defmodule Config do
    @moduledoc """
    Configuration for the controller.
    * `power` in watts
    * `efficiency` is a factor
    * `volume` in litres
    * `wait_time` in seconds
    """

    defstruct power: 2000, efficiency: 0.80, volume: 17, wait_time: 20

    @type t :: %Config{
      power: pos_integer,    # in Watts
      efficiency: float,     # factor
      volume: pos_integer,   # in litres
      wait_time: pos_integer # in seconds
    }

    @doc """
    Calculate the time the heater should be turned on in order to
    reach the desired temperature.

    Returns the time in seconds the heater should be turned on.

    TODO: use time unit size native to Elixir
    """
    def time(config, dtemp) do
      joules_1_litre = 4186

      (dtemp * joules_1_litre * config.volume) / (config.power * config.efficiency)
      |> max(config.wait_time)
      |> round
    end
  end

  alias Ctrl.Sample
  alias Ctrl.Controller

  defstruct config: nil, mode: :idle, since: 0, mash_temp: 0, max_temp: 0

  @opaque t :: %Controller{
    config: Config.t,
    mode: Sample.mode,
    since: Sample.time,
    mash_temp: Sample.temp,
    max_temp: Sample.temp
  }

  @spec new(Ctrl.Controller.Config.t) :: t
  def new(config \\ %Config{}),
    do: %Controller{config: config}

  @spec set_mash_temperature(t, Sample.temp) :: t
  def set_mash_temperature(controller, new_mash_temp),
    do: %{controller | mash_temp: new_mash_temp}

  @spec resume(t) :: t
  def resume(%{mode: :idle}=controller),
    do: %{controller | mode: :resting}

  def resume(controller),
    do: controller

  @spec pause(t) :: t
  def pause(controller),
    do: %{controller | mode: :idle}

  @spec update_sample(t, Sample.t) :: {t, Sample.t}
  def update_sample(controller, sample) do
    new_state = evaluate(controller, sample)
    {new_state, %{sample | mode: new_state.mode, mash_temperature: new_state.mash_temp}}
  end

  @spec evaluate(t, Sample.t) :: t
  @doc "Set heater mode to idle if the controller is off."
  def evaluate(%{mode: :idle}=controller, %Sample{}),
    do: controller

  def evaluate(%{mode: :resting, mash_temp: mash_temp} = controller, %Sample{time: now, temperature: temp}) when mash_temp - temp > 0.1,
    do: %{controller | mode: :heating, since: now}

  def evaluate(%{mode: :resting}=controller, %Sample{}),
    do: controller

  def evaluate(%{mode: :heating}=controller, %Sample{time: now, temperature: temp}) do
    since = controller.since
    dT = controller.mash_temp - temp
    if dT <= 0 or now >= since + Config.time(controller.config, dT) do
      %{controller | mode: :slacking, since: now, max_temp: temp}
    else
      %{controller | max_temp: max(controller.max_temp, temp)}
    end
  end

  def evaluate(%{mode: :slacking}=controller, %Sample{time: now, temperature: temp}) do
    since = controller.since
    end_time = since + controller.config.wait_time
    prev_temp = controller.max_temp
    if now > end_time and \
      abs(prev_temp - temp) < 0.05 do
      %{controller | mode: :resting, since: now}
    else
      controller
    end
  end

end


defmodule Ctrl.ControllerServer do
  @moduledoc "The Controller process (callbacks)"
  use GenServer

  alias Ctrl.Sample
  alias Ctrl.Controller.Config
  alias Ctrl.Controller

  ## Client interface

  def start_link(config \\ %Config{}, name \\ __MODULE__),
    do: GenServer.start_link(__MODULE__, config, [name: name])

  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

  def set_mash_temp(controller \\ __MODULE__, new_temp),
    do: GenServer.cast(controller, {:mash_temp, new_temp})

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update_sample(controller \\ __MODULE__, sample),
    do: GenServer.call(controller, sample)

  ## Server interface

  def init(config) do
    {:ok, Controller.new(config)}
  end

 @doc "Start the controller."
  def handle_cast(:resume, controller) do
    {:noreply, Controller.resume(controller)}
  end

  @doc "Stop the controller."
  def handle_cast(:pause, controller) do
    {:noreply, Controller.pause(controller)}
  end

  def handle_cast({:mash_temp, new_temp}, controller) do
    {:noreply, Controller.set_mash_temperature(controller, new_temp)}
  end

  @doc "handle temperature change when turned on."
  def handle_call(%Sample{} = sample, _from, controller) do
    {new_state, new_sample} = Controller.update_sample(controller, sample)
    {:reply, new_sample, new_state}
  end

end
