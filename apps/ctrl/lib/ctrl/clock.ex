defmodule Ctrl.Clock do
  @moduledoc false

  use GenServer

  @timeout 2000

  def start_link(callback_pid, timeout \\ @timeout, opts \\ []) do
    GenServer.start_link(__MODULE__, {callback_pid, timeout}, opts)
  end

  def init({_callback_pid, timeout}=state) do
    {:ok, state, timeout}
  end

  def handle_info(:timeout, {callback_pid, timeout}=state) do
    GenServer.cast(callback_pid, {:tick, DateTime.utc_now})
    {:noreply, state, timeout}
  end
end
