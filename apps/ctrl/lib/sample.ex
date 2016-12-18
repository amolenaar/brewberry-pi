defmodule Brewberry.Sample do

  @moduledoc """
  This module defines what a temperature sample looks like.

  * `:time` is a timestamp (`DateTime`),
  * `:temperature` the measured temperature (in &deg;C),
  * `heater` defines the current (desired) heater state (`:on` or `:off`),
  * `heating` defines the current (measured) heater state (`true` or `false`),
  * `mode` is the current mode of the controller (`:idle`, `:resting`, `:heating` or `:slacking`),
  * `:mash_temperature` contains the set mash temperature.
  """

  defstruct [:time, :temperature, :heater, :heating, :mode, :mash_temperature]

end
