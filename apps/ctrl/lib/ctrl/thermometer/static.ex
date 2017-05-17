defmodule Ctrl.Thermometer.Static do
  @moduledoc false
  @behaviour Ctrl.Thermometer

  def init, do: {:ok, nil}

  def handle_read(nil), do: 42

end
