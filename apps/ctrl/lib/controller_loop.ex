defmodule Brewberry.ControllerLoop do
  use GenServer
  @moduledoc false

  alias Brewberry.Sample

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
      |> Brewberry.Measure.update_sample
      |> Brewberry.MashTemperature.update_sample
      |> Brewberry.Controller.update_sample
      |> Brewberry.Heater.update_sample
      |> notify}
  end

  def handle_call(:state, _from, sample) do
    {:reply, sample, sample}
  end

  defp notify(sample) do
    Registry.dispatch(SampleNotification, :sample, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:sample, sample})
    end)
    sample
  end
end
