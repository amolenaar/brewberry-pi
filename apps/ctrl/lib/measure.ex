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
    @callback init() :: :ok
    @callback temperature?() :: Brewberry.Sample.temp
    @callback time?() :: non_neg_integer
  end

  defmodule FakeBackend do
    @behaviour Backend

    def init do
      :ok
    end

    def temperature? do
      time = DateTime.utc_now |> DateTime.to_unix
      :math.sin(time / 20)
    end

    def time? do
      DateTime.utc_now |> DateTime.to_unix
    end
  end

  defmodule StaticBackend do
    @behaviour Brewberry.Measure.Backend
    def init, do: :ok
    def temperature?, do: 42
    def time?, do: 12345
  end

  def update_sample(sample) do
    backend = Application.get_env(:ctrl, :measure_backend)
    %{sample | time: backend.time?, temperature: backend.temperature?}
  end

end
