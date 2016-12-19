defmodule ControllerTest do
  use ExUnit.Case

  alias Brewberry.Controller
  alias Brewberry.Sample

  doctest Controller

  setup do
    {:ok, ctrl} = Controller.start_link
    {:ok, controller: ctrl}
  end

  test "calculate the time the heater should be turned on" do
    config = %Controller.Config{}

    assert Controller.Config.time(config, 0) == 20
    assert Controller.Config.time(config, 2) == 89
    assert Controller.Config.time(config, 10) == 445
  end

  test "controller starts in idle mode" do
    %{mode: mode} = Controller.update_sample(%Sample{})

    assert mode == :idle
  end

  test "controller turned on starts in resting mode" do
    Controller.resume()
    %{mode: mode} = Controller.update_sample(%Sample{mode: :idle, temperature: 60, mash_temperature: 60})

    assert mode == :resting
  end

  test "controller remains resting when set temperature is not above current" do
    Controller.resume()
    %{mode: mode} = Controller.update_sample(%Sample{mode: :resting, temperature: 60, mash_temperature: 42})

    assert mode == :resting
  end

  test "controller starts heating when set temperature is above current" do
    Controller.resume()
    %{mode: mode} = Controller.update_sample(%Sample{mode: :resting, temperature: 42, mash_temperature: 60})

    assert mode == :heating
  end

  test "controller keeps heating when time is not done" do
    Controller.resume()
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(%Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(%Sample{mode: :heating, time: 2, temperature: 42, mash_temperature: 60})

    assert mode == :heating
  end

  test "controller stops heating is mash temperature is lower" do
    Controller.resume()
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(%Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(%Sample{mode: :heating, time: 2, temperature: 42, mash_temperature: 21})

    assert mode == :slacking
   end

  test "controller stops heating if time is over" do
    Controller.resume()
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(%Sample{mode: :resting, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(%Sample{mode: :heating, time: 100, temperature: 42, mash_temperature: 60})

    assert mode == :slacking
  end

  test "controller keeps slacking until temperature is declining" do
    Controller.resume()
    # 2 degrees matches 89 seconds of heating
    Controller.update_sample(%Sample{mode: :slacking, time: 0, temperature: 58, mash_temperature: 60})
    %{mode: mode} = Controller.update_sample(%Sample{mode: :slacking, time: 100, temperature: 58.04, mash_temperature: 60})

    assert mode == :resting
  end

end
