defmodule ControllerTest do
  use ExUnit.Case

  alias Brewberry.Controller

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

  test "controller can set temperarure", %{controller: ctrl} do
    Controller.temperature(ctrl, 60)
    {_, 60} = Controller.get_state(ctrl)
  end

end
