defmodule Ctrl.Thermometer.Fake do
  @moduledoc false
  @behaviour Ctrl.Thermometer

  def init do
    {:ok, nil}
  end

  def handle_read(nil) do
    time = DateTime.utc_now |> DateTime.to_unix
    :math.sin(time / 20)
  end

end
