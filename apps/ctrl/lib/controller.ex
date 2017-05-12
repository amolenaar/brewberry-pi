defmodule Brewberry.Controller do
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

  alias Brewberry.Sample
  alias Brewberry.Controller

  defstruct [:config, mode: :idle, time: 0, max_temp: 0]

  def new(config \\ Config),
    do: %Controller{config: config}

  def resume(%{mode: :idle}=controller),
    do: %{controller | mode: :resting}

  def resume(controller),
    do: controller

  def pause(controller),
    do: %{controller | mode: :idle}

  def update_sample(controller, sample) do
    new_state = evaluate(controller, sample)
    {new_state, %{sample | mode: new_state.mode}}
  end

  @doc "Set heater mode to idle if the controller is off."
  def evaluate(%{mode: :idle}=controller, %Sample{} = sample),
    do: controller

  def evaluate(controller, %Sample{mode: :idle, time: now}),
    do: %{controller | mode: :resting, time: now}

  def evaluate(controller, %Sample{mode: :resting, time: now, temperature: temp, mash_temperature: mash_temp}) when mash_temp - temp > 0.1,
    do: %{controller | mode: :heating, time: now}

  def evaluate(controller, %Sample{mode: :resting}),
    do: controller

  def evaluate(controller, %Sample{mode: :heating, time: now, temperature: temp, mash_temperature: mash_temp}) do
    time = controller.time
    dT = mash_temp - temp
    if dT <= 0 or now >= time + Config.time(controller.config, dT) do
      %{controller | mode: :slacking, time: now, max_temp: temp}
    else
      %{controller | max_temp: max(controller.max_temp, temp)}
    end
  end

  def evaluate(controller, %Sample{mode: :slacking, time: now, temperature: temp}) do
    time = controller.time
    end_time = time + controller.config.wait_time
    prev_temp = controller.max_temp
    if now > end_time and \
      abs(prev_temp - temp) < 0.05 do
      %{controller | mode: :resting, time: now}
    else
      controller
    end
  end

end


defmodule Brewberry.ControllerServer do
  @moduledoc "The Controller process (callbacks)"
  use GenServer

  alias Brewberry.Sample
  alias Brewberry.Controller.Config
  alias Brewberry.Controller

  ## Client interface

  def start_link(config \\ %Config{}, name \\ __MODULE__),
    do: GenServer.start_link(__MODULE__, config, [name: name])

  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

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

  @doc "handle temperature change when turned on."
  def handle_call(%Sample{} = sample, _from, controller) do
    {new_state, new_sample} = Controller.update_sample(controller, sample)
    {:reply, new_sample, new_state}
  end


end
