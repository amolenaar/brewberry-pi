defmodule ControllerTest do
  use ExUnit.Case

  alias Brewberry.Controller
  alias Brewberry.Controller.Config
  alias Brewberry.Sample

  doctest Controller

  setup do
    {:ok, ctrl} = Controller.start_link(%Config{}, :test)
    {:ok, controller: ctrl}
  end

  test "calculate the time the heater should be turned on" do
    config = %Controller.Config{}

    assert Controller.Config.time(config, 0) == 20
    assert Controller.Config.time(config, 2) == 89
    assert Controller.Config.time(config, 10) == 445
  end

  test "controller starts in idle mode", %{controller: ctrl} do
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{})

    assert mode == :idle
  end

  test "controller turned on starts in resting mode", %{controller: ctrl} do
    Controller.resume(ctrl)
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :idle, temperature: 60, mash_temperature: 60})

    assert mode == :resting
  end

  test "controller remains resting when set temperature is not above current", %{controller: ctrl} do
    Controller.resume(ctrl)
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :resting, temperature: 60, mash_temperature: 42})

    assert mode == :resting
  end

  test "controller starts heating when set temperature is above current", %{controller: ctrl} do
    Controller.resume(ctrl )
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :resting, temperature: 42, mash_temperature: 60})

    assert mode == :heating
  end

  test "controller keeps heating when time is not done", %{controller: ctrl} do
    Controller.resume(ctrl)
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 2, temperature: 42, mash_temperature: 60})

    assert mode == :heating
  end

  test "controller stops heating is mash temperature is lower", %{controller: ctrl} do
    Controller.resume(ctrl)
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 2, temperature: 42, mash_temperature: 21})

    assert mode == :slacking
   end

  test "controller stops heating if time is over", %{controller: ctrl} do
    Controller.resume(ctrl)
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(ctrl, %Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :heating, time: 100, temperature: 42, mash_temperature: 60})

    assert mode == :slacking
  end

  test "controller keeps slacking until temperature is declining", %{controller: ctrl} do
    Controller.resume(ctrl)
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(ctrl, %Sample{mode: :slacking, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(ctrl, %Sample{mode: :slacking, time: 100, temperature: 58.04, mash_temperature: 60})

    assert mode == :resting
  end

end
