defmodule MashTemperatureTest do
  @moduledoc false

  use ExUnit.Case

  alias Brewberry.MashTemperature
  alias Brewberry.Sample

  test "temperature can be set" do
    MashTemperature.start_link
    %{mash_temperature: 0} = MashTemperature.update_sample(%Sample{})

    MashTemperature.set!(42)

    %{mash_temperature: t} = MashTemperature.update_sample(%Sample{})
    assert t == 42
  end

end
