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

  test "controller starts in idle mode", %{controller: ctrl} do
    {:idle, _} = Controller.get_state(ctrl)
  end

  test "controller turned on starts in resting mode", %{controller: ctrl} do
    Controller.start(ctrl)
    {:resting, _} = Controller.get_state(ctrl)
  end

  test "controller remains resting when set temperature is not above current", %{controller: ctrl} do
    Controller.start(ctrl)
    Controller.temperature(ctrl, 60)
    Controller.update(ctrl, %Sample{temperature: 60})

    {:resting, _} = Controller.get_state(ctrl)
  end

  test "controller starts heating when set temperature is above current", %{controller: ctrl} do
    Controller.start(ctrl)
    Controller.temperature(ctrl, 60)
    Controller.update(ctrl, %Sample{temperature: 20})

    {:heating, _} = Controller.get_state(ctrl)
  end

  test "controller can set temperarure", %{controller: ctrl} do
    Controller.temperature(ctrl, 60)
    {_, 60} = Controller.get_state(ctrl)
  end

end
