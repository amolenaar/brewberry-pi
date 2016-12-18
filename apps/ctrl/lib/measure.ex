defmodule Brewberry.Measure do
  @moduledoc """
  Measure the current temperature.

  `update_sample(%Sample{})` is used to create a new sample based on the
  one passed as argument, with:

  * `temperature` updated to the newly read temperature
  * `time` updated
  """

  use GenServer

  defmodule FakeBackend do
    @behaviour Brewberry.Backend

    def temperature? do
      time = DateTime.utc_now |> DateTime.to_unix
      :math.sin(time / 20)
    end

    def time? do
      DateTime.utc_now
    end
  end


  def start_link(backend \\ FakeBackend) do
    GenServer.start_link(__MODULE__, backend, [name: __MODULE__])
  end

  def update_sample(sample) do
    GenServer.call(__MODULE__, sample)
  end

  ## Server side:

  def init(backend) do
    {:ok, backend}
  end

  def handle_call(sample, _from, backend) do
    {:reply, %{sample | time: backend.time?, temperature: backend.temperature?}, backend}
  end

end
