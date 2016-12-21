defmodule Brewberry.Heater do
  @moduledoc """
  The heater module turns the actual heater on and off based on the
  mode defined by controller.

  It reads the `mode` property and toggles the heater, setting the
  `heater` property as a result.
  """

  defmodule Backend do
    @moduledoc """
    Deal with heater I/O. Should return `:on` or `:off`,
    depending of (new) state of the heater.
    """
    @callback on!() :: atom
    @callback off!() :: atom
  end

  alias Brewberry.Sample

  defmodule FakeBackend do
    @behaviour Backend
    require Logger

    def on! do
#      Logger.info("Heater is :on")
      :on
    end

    def off! do
#      Logger.info("Heater is :off")
      :off
    end
  end

  def start_link(backend) do
    Agent.start_link(fn -> backend end, name: __MODULE__)
  end

  @doc "Handle `:heating` mode"
  def update_sample(%Sample{mode: :heating} = sample) do
    %{sample | heater: Agent.get_and_update(__MODULE__, fn backend -> {backend.on!, backend} end)}
  end

  @doc "Handle other modes, except `:heating`."
  def update_sample(%Sample{} = sample) do
    %{sample | heater: Agent.get_and_update(__MODULE__, fn backend -> {backend.off!, backend} end)}
  end

end
