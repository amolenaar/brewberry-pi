defmodule Ctrl.Heater do
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
    @callback init() :: :ok
    @callback on!() :: :on
    @callback off!() :: :off
  end

  alias Ctrl.Sample

  defmodule FakeBackend do
    @behaviour Backend

    def init, do: :ok
    def on!, do: :on
    def off!, do: :off
  end

  def start_link(backend) do
    Agent.start_link(fn ->
      :ok = backend.init()
      backend
    end, name: __MODULE__)
  end

  @doc "Handle `:heating` mode"
  def update_sample(%Sample{mode: :heating} = sample) do
    %{sample | heater: Agent.get_and_update(__MODULE__, fn backend -> {backend.on!, backend} end)}
  end

  @doc "Handle other modes, except `:heating`."
  def update_sample(%Sample{} = sample) do
    %{sample | heater: Agent.get_and_update(__MODULE__, fn backend -> {backend.off!, backend} end)}
  end

  @type t :: %{}
  @callback new() :: t
  @callback new() :: t

end


# The new code:
defmodule Ctrl.Heater.Fake do
  @behaviour Ctrl.Heater

  def new do
    %{}
  end

  def update(heater, :heating), do: {heater, :on}
  def update(heater, _mode   ), do: {heater, :off}
end