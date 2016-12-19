defmodule HeaterTest do
  @moduledoc false

  use ExUnit.Case

  alias Brewberry.Heater
  alias Brewberry.Sample

  defmodule StaticHeater do
    @behaviour Brewberry.Heater.Backend
    def on!(), do: :on
    def off!(), do: :off
  end

  test "heater can be turned on" do
        Heater.start_link StaticHeater
        %{heater: heater} = Heater.update_sample(%Sample{mode: :heating})
        assert heater == :on
  end

  test "heater can be turned off when in slacking mode" do
        Heater.start_link StaticHeater
        %{heater: heater} = Heater.update_sample(%Sample{mode: :slacking})
        assert heater == :off
  end

  test "heater can be turned off when in resting mode" do
        Heater.start_link StaticHeater
        %{heater: heater} = Heater.update_sample(%Sample{mode: :slacking})
        assert heater == :off
  end

  test "heater can be turned off when in idle mode" do
        Heater.start_link StaticHeater
        %{heater: heater} = Heater.update_sample(%Sample{mode: :idle})
        assert heater == :off
  end

end
