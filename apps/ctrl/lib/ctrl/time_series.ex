defmodule Ctrl.TimeSeries do
  use GenServer
  @moduledoc false

  @history_sec 10_800 # 3 hours
  @delay_sec 300 # 5 minutes

  def start_link(name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def update(time_series \\ __MODULE__, timestamp, value) do
    GenServer.cast(time_series, {:update, {timestamp, value}})
  end

  @doc """
  Obtain a list of series `{timestamp, value}` in ascending order.
  """
  def since(time_series \\ __MODULE__, since) do
    GenServer.call(time_series, {:series, since})
  end

  def last(time_series \\ __MODULE__) do
    GenServer.call(time_series, :last)
  end

  @doc """
  Truncate the log of sample up back to 3 hours from the most recent sample.
  """
  def truncate(time_series \\ __MODULE__) do
    GenServer.cast(time_series, {:truncate, @history_sec})
  end

  def stream() do
    Ctrl.TimeSeries.Dispatcher.stream
  end

  ## Server

  @doc """
  Initialize the server with an empty time series and an oldest sample timestamp.
  """
  def init(nil) do
    {:ok, {[], 0}}
  end

  def handle_cast({:sample, sample}, state) do
    handle_cast({:update, {sample.time, sample}}, state)
  end

  def handle_cast({:update, {ts, _val} = sample}, {samples, t}) when ts - @history_sec - @delay_sec >= t do
    truncate(self())
    Ctrl.TimeSeries.Dispatcher.notify sample
    {:noreply, {[sample | samples], t}}
  end

  def handle_cast({:update, sample}, {samples, t}) do
    Ctrl.TimeSeries.Dispatcher.notify sample
    {:noreply, {[sample | samples], t}}
  end

  def handle_cast({:truncate, interval}, {[{ts, _val} | _rest] = samples, oldest_ts}) when ts - interval >= oldest_ts do
    delete_from_ts = ts - interval
    {:noreply,
     {samples
     |> Enum.take_while(fn ({ts, _val}) -> ts > delete_from_ts end), delete_from_ts}}
  end

  def handle_cast({:truncate, _time}, state) do
    {:noreply, state}
  end

  def handle_call({:series, since}, _from, {samples, _t} = state) do
    {:reply, samples |> Enum.take_while(fn {t, _s} -> t > since end) |> Enum.reverse, state}
  end

  def handle_call(:last, _from, {[sample | _rest], _t} = state) do
    {:reply, sample, state}
  end

  def handle_call(:last, _from, {[], _t} = state) do
    {:reply, :no_data, state}
  end

end
