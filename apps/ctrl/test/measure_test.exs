defmodule MeasureTest do
  @moduledoc false

  use ExUnit.Case

  alias Brewberry.Measure
  alias Brewberry.Sample

  test "temperature can be set" do
    %{temperature: temperature, time: time} = Measure.update_sample(%Sample{})

    assert time == 12345
    assert temperature == 42
  end

end
