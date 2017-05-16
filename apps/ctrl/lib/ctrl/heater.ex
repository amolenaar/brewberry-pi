defmodule Ctrl.Heater do
  @moduledoc """
  The heater module turns the actual heater on and off based on the
  mode defined by controller.

  It reads the `mode` property and toggles the heater, setting the
  `heater` property as a result.
  """

  @opaque t :: %Ctrl.Heater{
    module: module,
    state: term
  }

  @type on_off :: :on | :off

  defstruct [:module, :state]

  @spec new(module) :: t
  def new(module) do
    {:ok, state} = module.init()
    %Ctrl.Heater{module: module, state: state}
  end

  @spec update(state :: term, Ctrl.Controller.mode) :: on_off
  def update(heater, mode) do
    apply(heater.module, :handle_update, [heater.state, mode])
  end

  @callback init() :: {:ok, term}
  @callback handle_update(state :: term, Ctrl.Controller.mode) :: on_off

end


defmodule Ctrl.Heater.Fake do
  @moduledoc false
  @behaviour Ctrl.Heater

  def init do
    {:ok, nil}
  end

  def handle_update(_heater, :heating), do: :on
  def handle_update(_heater, _mode), do: :off
end

defmodule Ctrl.Heater.Kettle do
  @moduledoc false
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
