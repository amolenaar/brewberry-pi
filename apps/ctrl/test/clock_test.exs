defmodule ClockTest do
  use ExUnit.Case

  @moduledoc false

  alias Ctrl.Clock

  @interval 20

  test "clock sends tick on interval" do
    {:ok, _} = Clock.start_link(self(), @interval, [])

    assert_receive {:"$gen_cast", {:tick, time1}}, @interval * 2
    assert_receive {:"$gen_cast", {:tick, time2}}, @interval * 2

    dt = (time2 |> to_milliseconds) - (time1 |> to_milliseconds)
    assert abs(dt - @interval) <= 10
  end

  defp to_milliseconds(d), do: DateTime.to_unix(d, :millisecond)
end
