defmodule Backends do
  @moduledoc """
  Raspberry Pi backends for our
  """

  alias Rpi.{ Gpio, W1 }

  defmodule HeaterBackend do
    @behaviour Brewberry.Heater.Backend

    @pin 17

    def init do
      Gpio.output_pin @pin
    end

    def on! do
      Gpio.set_pin @pin, :on
    end

    def off! do
      Gpio.set_pin @pin, :off
    end
  end


  defmodule MeasureBackend do
    @behaviour Brewberry.Measure.Backend

    def temperature? do
      W1.read W1.sensor
    end

    def time? do
      DateTime.utc_now |> DateTime.to_unix
    end
  end
end
