defmodule Ctrl.Thermometer do
  @moduledoc false

  @opaque t :: map

  @type temp :: float | integer

  @callback new() :: t
  @callback read(t) :: temp

end

defmodule Ctrl.Thermometer.Fake do
  @behaviour Ctrl.Thermometer

  def new do
    %{}
  end

  def read(%{}) do
    time = DateTime.utc_now |> DateTime.to_unix
    :math.sin(time / 20)
  end

end

defmodule Ctrl.Thermometer.Static do
  @behaviour Ctrl.Thermometer

  def new, do: %{}

  def read(%{}), do: 42

end

defmodule Ctrl.Thermometer.Digital do
  @behaviour Ctrl.Thermometer

  # TODO: Consideration: should I create separate processes (genservers) for the IO bits?

  alias Ctrl.Rpi.W1
  alias Ctrl.Thermometer.Digital

  defstruct [:sensor]

  def new, do: %Digital{sensor: W1.sensor}

  def read(%Digital{sensor: sensor}), do: W1.read sensor

end

