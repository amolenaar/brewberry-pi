defmodule Ctrl.ControllerLoop do
  use GenServer
  @moduledoc false

  alias Ctrl.Sample

  def start_link do
    GenServer.start_link(__MODULE__, %Sample{}, [name: __MODULE__])
  end

  def state? do
    GenServer.call(__MODULE__, :state)
  end

  def run! do
    GenServer.cast(__MODULE__, :tick)
  end

  def run_infinite! do
    run!()
    :timer.sleep(2000)
    run_infinite!()
  end

  ## Server callbacks:

  def init(sample) do
#    {:ok, _tref} = :timer.apply_interval(2000, __MODULE__, &run!, [])
    {:ok, sample}
  end

  def handle_cast(:tick, sample) do
    {:noreply, sample
      |> Ctrl.Measure.update_sample
      |> Ctrl.ControllerServer.update_sample
      |> Ctrl.Heater.update_sample
      |> update_time_series
      |> Ctrl.Dispatcher.notify}
  end

  def handle_call(:state, _from, sample) do
    {:reply, sample, sample}
  end

  defp update_time_series(sample) do
    Ctrl.TimeSeries.update sample.time, sample
    sample
  end

end
