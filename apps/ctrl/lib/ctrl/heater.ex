defmodule Ctrl.Heater do
  @moduledoc """
  The heater module turns the actual heater on and off based on the
  mode defined by controller.

  It reads the `mode` property and toggles the heater, setting the
  `heater` property as a result.
  """

  @type on_off :: :on | :off

  @callback init() :: :ok
  @callback update(Ctrl.Controller.mode) :: on_off

end


defmodule Ctrl.Heater.Fake do
  @behaviour Ctrl.Heater

  def init do
    :ok
  end

  def update(:heating), do: :on
  def update(_mode   ), do: :off
end

defmodule Ctrl.Heater.Kettle do
  @behaviour Ctrl.Heater

  @pin 17

  alias Ctrl.Rpi.Gpio

  def init do
    Gpio.output_pin @pin
    :ok
  end

  def update(:heating) do
    Gpio.set_pin @pin, :on
    :on
  end

  def update(_mode) do
    Gpio.set_pin @pin, :off
    :off
  end

end
