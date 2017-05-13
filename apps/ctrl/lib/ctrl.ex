defmodule Ctrl do
  use Application

  @moduledoc false

  alias Ctrl.ControllerServer
  alias Ctrl.Dispatcher
  alias Ctrl.Metronome
  alias Ctrl.TimeSeries

  @heater_backend Application.get_env(:ctrl, :heater_backend)

  @doc """
  Entrypoint for the Ctrl (controller) application.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ControllerServer, [], restart: :permanent),
      supervisor(Dispatcher, [], restart: :permanent),
      worker(TimeSeries, [], restart: :permanent),
      worker(Metronome, [ControllerServer], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Ctrl]
    Supervisor.start_link(children, opts)
  end

end
