defmodule TestHelper do
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

ExUnit.start()
