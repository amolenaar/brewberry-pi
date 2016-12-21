defmodule Brewberry.Sample do

  @moduledoc """
  This module defines what a temperature sample looks like.

  * `:time` is a unix timestamp (in seconds),
  * `:temperature` the measured temperature (in &deg;C),
  * `heater` defines the current (desired) heater state (`:on` or `:off`),
  * `mode` is the current mode of the controller (`:idle`, `:resting`, `:heating` or `:slacking`),
  * `:mash_temperature` contains the set mash temperature.
  """

  defstruct [:time, :temperature, :heater, :mode, :mash_temperature]

end
