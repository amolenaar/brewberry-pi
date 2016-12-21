defmodule HeaterTest do
  use ExUnit.Case

  @moduledoc false

  @moduletag :capture_log

  alias Brewberry.Heater
  alias Brewberry.Heater.FakeBackend
  alias Brewberry.Sample

  test "heater can be turned on" do
        Heater.start_link FakeBackend
        %{heater: heater} = Heater.update_sample(%Sample{mode: :heating})
        assert heater == :on
  end

  test "heater can be turned off when in slacking mode" do
        Heater.start_link FakeBackend
        %{heater: heater} = Heater.update_sample(%Sample{mode: :slacking})
        assert heater == :off
  end

  test "heater can be turned off when in resting mode" do
        Heater.start_link FakeBackend
        %{heater: heater} = Heater.update_sample(%Sample{mode: :slacking})
        assert heater == :off
  end

  test "heater can be turned off when in idle mode" do
        Heater.start_link FakeBackend
        %{heater: heater} = Heater.update_sample(%Sample{mode: :idle})
        assert heater == :off
  end

end
