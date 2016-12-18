defmodule Brewberry.MashTemperature do
  @moduledoc """
  Deal with mash temperature setting in the sample/control loop.

  A temperature can be set with the `set!` function and can be used to
  update a sample with the req
  """

  def start_link() do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def set!(temp) do
    Agent.update(__MODULE__, fn _t -> temp end)
  end

  def update_sample(sample) do
    %{sample | mash_temperature: Agent.get(__MODULE__, &(&1))}
  end
end
