defmodule Ctrl.Metronome do
  @moduledoc """
  Metronome sends a `:tick` every so many milliseconds (default 2000).

  It does a `GenServer` cast of a `{:tick, time}` message, where time is a
  `DateTime` instance.
  """
  use GenServer

  @type time :: DateTime.t

  @timeout 2000

  ## Client interface

  @spec start_link(pid, non_neg_integer, list) :: {:ok, pid}
  def start_link(callback_pid, timeout \\ @timeout, opts \\ []) do
    GenServer.start_link(__MODULE__, {callback_pid, timeout}, opts)
  end


  ## Server callbacks

  def init({_callback_pid, timeout} = state) do
    {:ok, state, timeout}
  end

  def handle_info(:timeout, {callback_pid, timeout} = state) do
    GenServer.cast(callback_pid, {:tick, DateTime.utc_now})
    {:noreply, state, timeout}
  end
end
