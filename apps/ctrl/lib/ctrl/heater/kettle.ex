defmodule Ctrl.Heater.Kettle do
  @moduledoc "The kettle."
  @behaviour Ctrl.Heater

  @pin 17

  alias Ctrl.Rpi.Gpio

  def init do
    Gpio.output_pin @pin
    {:ok, nil}
  end

  def handle_update(_heater, :heating) do
    Gpio.set_pin @pin, :on
    :on
  end

  def handle_update(_heater, _mode) do
    Gpio.set_pin @pin, :off
    :off
  end

end
