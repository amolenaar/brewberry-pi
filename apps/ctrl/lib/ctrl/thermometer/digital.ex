defmodule Ctrl.Thermometer.Digital do
  @moduledoc "DS18B20 thermometer, mounted on pin 17."
  @behaviour Ctrl.Thermometer

  alias Ctrl.Rpi.W1

  def init, do: {:ok, W1.sensor}

  def handle_read(sensor), do: W1.read sensor

end
