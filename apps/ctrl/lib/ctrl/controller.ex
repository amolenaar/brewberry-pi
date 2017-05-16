defmodule Ctrl.Controller do
  @moduledoc """
  The controller used to keep my mash at a constant temperature.
              ,---------.
              v         |
             Idle ----->|
      :resume |         |
              v         |
        ,-> Resting --->|
        |     | dT>0.1  |
        |     v         |
        |   Heating --->|
        |     | dt=0    |
        |     v         |
        |   Slacking ---' :pause
        |     | dT<0.05
        `-----'

  * `dT` is delta in temperature over a sliding window of _n_ samples
  * `dt` is the time the heater should be heating.
  """

  alias Ctrl.BrewHouse
  alias Ctrl.Controller

  defstruct brew_house: nil, mode: :idle, since: 0, mash_temp: 0, max_temp: 0

  @type mode :: :idle | :heating | :slacking | :resting
  @type time :: Ctrl.Metronome.time
  @type timestamp :: non_neg_integer
  @type temp :: Ctrl.Thermometer.temp
  @opaque t :: %Controller{
    brew_house: BrewHouse.t,
    mode: mode,
    since: timestamp,
    mash_temp: temp,
    max_temp: temp
  }

  @spec new(BrewHouse.t) :: t
  def new(brew_house),
    do: %Controller{brew_house: brew_house}

  @spec mash_temperature(t, temp) :: t
  def mash_temperature(controller, new_mash_temp),
    do: %{controller | mash_temp: new_mash_temp}

  @spec mash_temperature?(t) :: temp
  def mash_temperature?(controller),
    do: controller.mash_temp

  @spec mode?(t) :: mode
  def mode?(controller),
    do: controller.mode

  @spec resume(t) :: t
  def resume(%{mode: :idle} = controller),
    do: %{controller | mode: :resting}

  def resume(controller),
    do: controller

  @spec pause(t) :: t
  def pause(controller),
    do: %{controller | mode: :idle}

  @spec update(t, time, temp) :: t
  def update(controller, now, temp) do
    evaluate(controller, now |> DateTime.to_unix, temp)
  end

  defp evaluate(%{mode: :idle} = controller, _now, _temp),
    do: controller

  defp evaluate(%{mode: :resting, mash_temp: mash_temp} = controller, now, temp) when mash_temp - temp > 0.1,
    do: %{controller | mode: :heating, since: now}

  defp evaluate(%{mode: :resting} = controller, _now, _temp),
    do: controller

  defp evaluate(%{mode: :heating} = controller, now, temp) do
    since = controller.since
    dt = controller.mash_temp - temp
    if dt <= 0 or now >= since + BrewHouse.time(controller.brew_house, dt) do
      %{controller | mode: :slacking, since: now, max_temp: temp}
    else
      controller
    end
  end

  defp evaluate(%{mode: :slacking} = controller, now, temp) do
    since = controller.since
    end_time = since + controller.brew_house.wait_time
    max_temp = controller.max_temp
    if now > end_time and \
      (temp - max_temp) < 0.05 do
      %{controller | mode: :resting, since: now}
    else
      %{controller | max_temp: max(controller.max_temp, temp)}
    end
  end

end
