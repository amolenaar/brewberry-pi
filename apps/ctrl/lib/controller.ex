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

    def handle_call({:state}, _from, {action, temp, _config} = state) do
      {:reply, {action, temp}, state}
    end

    def handle_cast({:temperature, temperature}, {action, _temp, config}) do
      {:noreply, {action, temperature, config}}
    end

    def handle_cast(%Sample{} = _sample, {:resting, _temp, _config} = state) do
      {:noreply, state}
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
