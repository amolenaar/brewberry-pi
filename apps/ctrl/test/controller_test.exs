defmodule ControllerTest do
  use ExUnit.Case

  alias Ctrl.BrewHouse
  alias Ctrl.Controller

  doctest Controller

  setup do
    ctrl = Controller.new(BrewHouse.new)
    |> Controller.resume()
    |> Controller.mash_temperature(60)
    {:ok, controller: ctrl}
  end

  test "calculate the time the heater should be turned on" do
    config = BrewHouse.new

    assert BrewHouse.time(config, 0) == 20
    assert BrewHouse.time(config, 2) == 89
    assert BrewHouse.time(config, 10) == 445
  end

  test "controller starts in idle mode" do
    assert %{mode: :idle} = Controller.new(BrewHouse.new)
  end

  test "controller turned on starts in resting mode", %{controller: ctrl} do
    assert :resting = Controller.update(ctrl, now(), 60) |> Controller.mode?
  end

  test "controller remains resting when set temperature is not above current", %{controller: ctrl} do
    ctrl = Controller.update(ctrl, now(), 70)

    assert :resting = Controller.update(ctrl, later(), 70) |> Controller.mode?
  end

  test "controller starts heating when set temperature is above current", %{controller: ctrl} do
    assert :heating = Controller.update(ctrl, now(), 42) |> Controller.mode?
  end

  test "controller keeps heating when time is not done", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    ctrl = Controller.update(ctrl, now(), 58)

    assert :heating = Controller.update(ctrl, later(), 42) |> Controller.mode?
  end

  test "controller stops heating is mash temperature is lower", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    ctrl = Controller.update(ctrl, now(), 58)
    ctrl = Controller.mash_temperature(ctrl, 21)

    assert :slacking = Controller.update(ctrl, later(), 42) |> Controller.mode?

   end

  test "controller stops heating if time is over", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    ctrl = Controller.update(ctrl, now(), 58)
    assert :heating = Controller.mode? ctrl
    assert :slacking = Controller.update(ctrl, later(), 58) |> Controller.mode?
  end

  test "controller keeps slacking until temperature is declining", %{controller: ctrl} do
    ctrl = Controller.update(ctrl, now(), 58)
    assert %{mode: :heating} = ctrl

    # 2 degrees matches 89 seconds of heating
    ctrl = Controller.update(ctrl, later(), 58)
    assert %{mode: :slacking} = ctrl

    # default fixed type for slacking state is 20 seconds
    assert :resting = Controller.update(ctrl, even_later(), 58.04) |> Controller.mode?
  end

  defp now, do: DateTime.from_unix! 0
  defp later, do: DateTime.from_unix! 100
  defp even_later, do: DateTime.from_unix! 121
end
