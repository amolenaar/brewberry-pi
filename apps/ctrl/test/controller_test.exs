defmodule ControllerTest do
  use ExUnit.Case

  alias Brewberry.Controller
  alias Brewberry.Controller.Config
  alias Brewberry.Sample

  doctest Controller

  setup do
    ctrl = Controller.new(%Config{})
    |> Controller.resume()
    |> Controller.set_mash_temperature(60)
    {:ok, controller: ctrl}
  end

  test "calculate the time the heater should be turned on" do
    config = %Controller.Config{}

    assert Controller.Config.time(config, 0) == 20
    assert Controller.Config.time(config, 2) == 89
    assert Controller.Config.time(config, 10) == 445
  end

  test "controller starts in idle mode" do
    assert %{mode: :idle} = Controller.new(%Config{})
  end

  test "controller turned on starts in resting mode", %{controller: ctrl} do
    assert {_, %{mode: :resting}} = Controller.update_sample(ctrl, %Sample{mode: :idle, temperature: 60})
  end

  test "controller sets mash temperature on sample", %{controller: ctrl} do
    assert {_, %{mash_temperature: 60}} = Controller.update_sample(ctrl, %Sample{mode: :idle, temperature: 60})
  end

  test "controller remains resting when set temperature is not above current", %{controller: ctrl} do
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :idle, temperature: 70})

    assert {_, %{mode: :resting}} = Controller.update_sample(ctrl, %Sample{mode: :resting, temperature: 70})
  end

  test "controller starts heating when set temperature is above current", %{controller: ctrl} do
    assert {_, %{mode: :heating}} = Controller.update_sample(ctrl, %Sample{mode: :resting, temperature: 42})
  end

  test "controller keeps heating when time is not done", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58})

    assert {_, %{mode: :heating}} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 2, temperature: 42})
  end

  test "controller stops heating is mash temperature is lower", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58})
    ctrl = Controller.set_mash_temperature(ctrl, 21)

    assert {_, %{mode: :slacking}} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 2, temperature: 42})

   end

  test "controller stops heating if time is over", %{controller: ctrl} do
    # 2 degrees matches 89 seconds of heating
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58})

    assert {_, %{mode: :slacking}} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 100, temperature: 58})
  end

  test "controller keeps slacking until temperature is declining", %{controller: ctrl} do
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :idle, time: 0, temperature: 58})
    # 2 degrees matches 89 seconds of heating
    {ctrl, _} = Controller.update_sample(ctrl, %Sample{mode: :slacking, time: 0, temperature: 58})

    assert {_, %{mode: :resting}} = Controller.update_sample(ctrl, %Sample{mode: :slacking, time: 100, temperature: 58.04})
  end

end
