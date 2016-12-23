defmodule Brewberry.Measure do
  use GenServer

  @moduledoc """
  Measure the current temperature.

  `update_sample(%Sample{})` is used to create a new sample based on the
  one passed as argument, with:

  * `temperature` updated to the newly read temperature
  * `time` updated
  """

  defmodule Backend do
    @callback temperature?() :: float
    @callback time?() :: DateTime
  end

  defmodule FakeBackend do
    @behaviour Backend

    def temperature? do
      time = DateTime.utc_now |> DateTime.to_unix
      :math.sin(time / 20)
    end

    def time? do
      DateTime.utc_now |> DateTime.to_unix
    end
  end


  def start_link(backend \\ FakeBackend, name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, backend, [name: name])
  end

  def update_sample(measure \\ __MODULE__, sample) do
    GenServer.call(measure, sample)
  end


  ## Server side:

  def init(backend) do
    {:ok, backend}
  end

  def handle_call(sample, _from, backend) do
    {:reply, %{sample | time: backend.time?, temperature: backend.temperature?}, backend}
  end

end
