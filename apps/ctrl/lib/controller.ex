defmodule Brewberry.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.
  """
  use GenServer

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
    """
    def time(config, dtemp) do
      joules_1_litre = 4186

      (dtemp * joules_1_litre * config.volume) / (config.power * config.efficiency)
      |> max(config.wait_time)
      |> round
    end
  end

  alias Brewberry.Sample

  @doc """
  Starts the registry.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, %Config{}, [])
  end

  def start_link(config) do
    GenServer.start_link(__MODULE__, config, [])
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`.
  """
  def update(controller, %Sample{} = sample) do
    GenServer.cast(controller, sample)
  end

  def state(controller) do
    GenServer.call(controller, {:state})
  end

  ## Server Callbacks

  def init(config) do
    {:ok, {:resting, nil, config}}
  end

  def handle_call({:state}, _from, {action, _, _} = state) do
    {:reply, action, state}
  end

  def handle_cast(%Sample{} = _sample, {:resting, _temp, _config} = state) do
    {:noreply, state}
  end


end
