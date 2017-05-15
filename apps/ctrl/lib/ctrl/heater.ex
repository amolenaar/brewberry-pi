defmodule Ctrl.Heater do
  @moduledoc """
  The heater module turns the actual heater on and off based on the
  mode defined by controller.

  It reads the `mode` property and toggles the heater, setting the
  `heater` property as a result.
  """

  @type t :: map

  @type on_off :: :on | :off

  @callback new() :: t
  @callback update(t, Ctrl.Controller.mode) :: on_off

end


defmodule Ctrl.Heater.Fake do
  @behaviour Ctrl.Heater

  def new do
    %{}
  end

  def update(_heater, :heating), do: :on
  def update(_heater, _mode   ), do: :off
end

defmodule Ctrl.Heater.Kettle do
  @behaviour Ctrl.Heater

  @pin 17

  alias Ctrl.Rpi.Gpio

  def new do
    Gpio.output_pin @pin
    %{}
  end

  def update(_heater, :heating) do
    Gpio.set_pin @pin, :on
    :on
  end

  def update(_heater, _mode) do
    Gpio.set_pin @pin, :off
    :off
  end

end
