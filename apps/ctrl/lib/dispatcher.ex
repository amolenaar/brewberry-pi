defmodule Brewberry.Dispatcher do
  @moduledoc """
  A Register based dispatcher for samples.
  """

  @registry SampleNotification

  def start_link() do
    Registry.start_link(:duplicate, @registry)
  end

  @doc """
  Register the current process for new samples and state changes on
  the controller.
  """
  def register() do
    Registry.register(@registry, :sample, [])
  end

  @doc """
  Unregister the current process.
  """
  def unregister() do
    Registry.unregister(@registry, :sample)
  end

  def listener() do
    receive do
      {:sample, sample} -> {[{sample.time, sample}], nil}
    end
  end

  @doc """
  Listen to events generated by the controller and expose them as a stream of events.
  A `{id, sample}` tuple is returned.
  """
  def stream do
    Stream.resource(&register/0, fn (_arg) -> listener() end, fn (_arg) -> unregister() end)
  end

  def notify(sample) do
    Registry.dispatch(@registry, :sample, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:sample, sample})
    end)
    sample
  end

end
