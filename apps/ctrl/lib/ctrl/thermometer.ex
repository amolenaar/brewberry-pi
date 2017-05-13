defmodule Ctrl.Thermometer do
  @moduledoc false

  @opaque t :: %{}

#  @callback new() :: (() -> float)

  @callback new() :: t
  @callback read(t) :: float

end

defmodule Ctrl.Thermometer.Fake do
  @behaviour Ctrl.Thermometer

  defstruct []
  def new do
    %Ctrl.Thermometer.Fake{}
  end

  def read(%Ctrl.Thermometer.Fake{}) do
    time = DateTime.utc_now |> DateTime.to_unix
    :math.sin(time / 20)
  end

end
