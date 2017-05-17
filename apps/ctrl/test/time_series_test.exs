defmodule TimeSeriesTest do
  use ExUnit.Case
  @moduledoc false

  alias Ctrl.TimeSeries

  @one_hour 3600
  @dummy_val 1

  setup do
    {:ok, pid} = TimeSeries.start_link(:test)
    {:ok, time_series: pid}
  end

  test "should store a time series", %{time_series: time_series} do
    TimeSeries.update(time_series, 1000, %{val: 100})
    TimeSeries.update(time_series, 2000, %{val: 20})

    assert TimeSeries.since(time_series, 0) == [{1000, %{val: 100}}, {2000, %{val: 20}}]
  end

  test "should get a time series since a start date", %{time_series: time_series} do
    TimeSeries.update(time_series, 1000, %{val: 100})
    TimeSeries.update(time_series, 2000, %{val: 20})

    assert TimeSeries.since(time_series, 100) == [{1000, %{val: 100}}, {2000, %{val: 20}}]
    assert TimeSeries.since(time_series, 1000) == [{2000, %{val: 20}}]
    assert TimeSeries.since(time_series, 2001) == []
  end

  test "series should truncate after 3 hours", %{time_series: time_series} do
    TimeSeries.update(time_series, 1 * @one_hour, @dummy_val)
    TimeSeries.update(time_series, 2 * @one_hour - 1, @dummy_val)
    TimeSeries.update(time_series, 2 * @one_hour, @dummy_val)
    TimeSeries.update(time_series, 2 * @one_hour + 1, @dummy_val)
    TimeSeries.update(time_series, 3 * @one_hour, @dummy_val)
    TimeSeries.update(time_series, 5 * @one_hour, @dummy_val)

    wait_until 10, fn -> {:messages, []} = :erlang.process_info(time_series, :messages) end

    assert TimeSeries.since(time_series, 0) == [{2 * @one_hour + 1, @dummy_val}, {3 * @one_hour, @dummy_val}, {5 * @one_hour, @dummy_val}]
  end

  def wait_until(0, fun), do: fun.()

  def wait_until(timeout, fun) do
    try do
      fun.()
    rescue
      MatchError ->
        :timer.sleep(10)
        wait_until(max(0, timeout - 10), fun)
    end
  end

end
