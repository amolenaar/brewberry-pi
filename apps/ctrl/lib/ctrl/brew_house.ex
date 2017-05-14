defmodule Ctrl.BrewHouse do
  @moduledoc """
  Configuration for the brew house.
  * `power` in watts
  * `efficiency` factor
  * `volume` in litres
  * `wait_time` in seconds
  """

  alias Ctrl.BrewHouse
  defstruct power: 2000, efficiency: 0.80, volume: 17, wait_time: 20

  @joules_per_litre 4186

  @type t :: %BrewHouse{
    power: pos_integer,    # in Watts
    efficiency: float,     # factor
    volume: pos_integer,   # in litres
    wait_time: pos_integer # in seconds
  }


  @doc """
  Create a new brew house config based on the
  ctrl.brew_house config setting
  """
  def new do
    struct(BrewHouse, Application.get_env(:ctrl, :brew_house))
  end

  @spec time(t, float) :: integer

  @doc """
  Calculate the time the heater should be turned on in order to
  reach the desired temperature.

  Returns the time in seconds the heater should be turned on.

  TODO: use time unit size native to Elixir
  """
  def time(brew_house, dtemp) do
    (dtemp * @joules_per_litre * brew_house.volume) / (brew_house.power * brew_house.efficiency)
    |> max(brew_house.wait_time)
    |> round
  end

end
