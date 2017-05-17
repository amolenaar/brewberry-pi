defmodule Ctrl.Heater.Fake do
  @moduledoc false
  @behaviour Ctrl.Heater

  def init do
    {:ok, nil}
  end

  def handle_update(_heater, :heating), do: :on
  def handle_update(_heater, _mode), do: :off
end
