defmodule Brewberry.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.
              ,---------.
              v         |
             Off        | Off is an internal state.
              |<--------|
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

  defstruct mode: :off, time: 0, max_temp: 0

  defmodule Server do
    @moduledoc "The Controller process (callbacks)"
    use GenServer

    def init(config) do
      {:ok, {%Controller{}, config}}
    end

   @doc "Start the controller."
    def handle_cast(:resume, {%{mode: :off}=server_state, config}) do
      {:noreply, {%{server_state | mode: :idle}, config}}
    end

    def handle_cast(:resume, {server_state, config}) do
      {:noreply, {server_state, config}}
    end

   @doc "Stop the controller."
    def handle_cast(:pause, {server_state, config}) do
      {:noreply, {%{server_state | mode: :off}, config}}
    end

    @doc "Set heater mode to idle if the controller is off."
    def handle_call(%Sample{} = sample, _from, {%{mode: :off}, config}) do
      {:reply, %{sample | heater: :off, mode: :idle}, {%Controller{mode: :off, time: sample.time}, config}}
    end

    @doc "handle temperature change when turned on."
    def handle_call(%Sample{} = sample, _from, {server_state, config}) do
      new_state = evaluate(sample, server_state, config)
      {:reply, %{sample | mode: new_state.mode}, {new_state, config}}
    end

    defp evaluate(%Sample{mode: :idle, time: now}, _server_state, _config),
      do: %Controller{mode: :resting, time: now}

    defp evaluate(%Sample{mode: :resting, time: now, temperature: temp, mash_temperature: mash_temp}, _server_state, _config) when mash_temp - temp > 0.1,
      do: %Controller{mode: :heating, time: now}

    defp evaluate(%Sample{mode: :resting}, server_state, _config),
      do: server_state

    defp evaluate(%Sample{mode: :heating, time: now, temperature: temp, mash_temperature: mash_temp}, server_state, config) do
      time = server_state.time
      dT = mash_temp - temp
      if dT <= 0 or now >= time + Config.time(config, dT) do
        %Controller{mode: :slacking, time: now, max_temp: temp}
      else
        %{server_state | max_temp: max(server_state.max_temp, temp)}
      end
    end

    defp evaluate(%Sample{mode: :slacking, time: now, temperature: temp}, server_state, config) do
      time = server_state.time
      end_time = time + config.wait_time
      prev_temp = server_state.max_temp
      if now > end_time and \
        abs(prev_temp - temp) < 0.05 do
        %Controller{mode: :resting, time: now}
      else
        server_state
      end
    end

  end

  ## Client interface

  @doc """
  Starts the registry.
  """
  def start_link(config \\ %Config{}, name \\ __MODULE__),
    do: GenServer.start_link(Server, config, [name: name])

  def resume(controller \\ __MODULE__),
    do: GenServer.cast(controller, :resume)

  def pause(controller \\ __MODULE__),
    do: GenServer.cast(controller, :pause)

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update_sample(controller \\ __MODULE__, sample),
    do: GenServer.call(controller, sample)

end
