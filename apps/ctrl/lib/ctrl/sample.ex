defmodule Ctrl.Sample do
  @moduledoc """
  This module defines what a temperature sample looks like.

  * `:time` is a unix timestamp (in seconds),
  * `:temperature` the measured temperature (in &deg;C),
  * `:heater` defines the current (desired) heater state (`:on` or `:off`),
  * `:mode` is the current mode of the controller (`:idle`, `:resting`, `:heating` or `:slacking`),
  * `:mash_temperature` contains the set mash temperature.
  """

  @fields [:time, :temperature, :heater, :mode, :mash_temperature]

  @enforce_keys @fields
  defstruct @fields

  @type time :: non_neg_integer
  @type temp :: Ctrl.Thermometer.temp
  @type on_off :: Ctrl.Heater.on_off
  @type mode :: Ctrl.Controller.mode
  @type t :: %Ctrl.Sample{
    time: time,
    temperature: temp,
    heater: on_off,
    mode: mode,
    mash_temperature: temp
  }

  def new(fields) do
    struct! Ctrl.Sample, fields
  end

end
