defmodule Brewberry.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.
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


  defmodule Server do
    @moduledoc "The Controller process (callbacks)"
    use GenServer

    def init(config) do
      {:ok, {:idle, 0, config}}
    end

    @doc"Read state (mode + temperature) from controller"
    def handle_call({:state}, _from, {mode, temp, _config} = state) do
      {:reply, {mode, temp}, state}
    end


   @doc "Start the controller"
    def handle_cast({:start}, {_mode, temp, config}) do
      {:noreply, {:resting, temp, config}}
    end

    @doc "Set the temperature"
    def handle_cast({:temperature, temperature}, {mode, _temp, config}) do
      {:noreply, {mode, temperature, config}}
    end

    @doc "In Idle state heating is turned of an nothing else happens"
    def handle_cast(%Sample{} = _sample, {:idle, _temp, _config} = state) do
      # TODO: turn heating off
      {:noreply, state}
    end

    @doc """
            if io.read_heater():
                io.set_heater(Off)

            if mash_temperature - io.read_temperature() > 0.1:
                return Heating
            return Resting
    """
    def handle_cast(%Sample{temperature: sample_temp}, {:resting, temp, config}) do
      # TODO: Ensure heater is turned off
      next_mode = if temp - sample_temp > 0.1, do: :heating, else: :resting
      {:noreply, {next_mode, temp, config}}
    end

    @doc """
            dT = mash_temperature - io.read_temperature()

            if dT <= 0:
                return Resting

            end_time = io.read_time() + config.time(dT)

            io.set_heater(On)

            @state
            def Heating():
                t = io.read_time()
                if t >= end_time:
                    return Slacking
                return Heating
            return Heating
    """
    def handle_cast(%Sample{time: sample_time, temperature: sample_temp}, {:heating, temp, config}) do
      dT = temp - sample_temp
      if dT < 0 do
        {:resting, temp,config}
      else
        _end_time = sample_time + Config.time(config, dT)
      end
    end
  end

  ## Client interface

  @doc """
  Starts the registry.
  """
  def start_link() do
    GenServer.start_link(Server, %Config{}, [])
  end

  def start_link(config) do
    GenServer.start_link(Server, config, [])
  end

  def start(controller) do
    GenServer.cast(controller, {:start})
  end

  def temperature(controller, temperature) do
    GenServer.cast(controller, {:temperature, temperature})
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update(controller, %Sample{} = sample) do
    GenServer.cast(controller, sample)
  end

  def get_state(controller) do
    GenServer.call(controller, {:state})
  end

end
