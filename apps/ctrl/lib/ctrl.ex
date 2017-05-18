defmodule Ctrl do
  @moduledoc """
  The Ctrl (Controller) application.
  """
  use Application


  alias Ctrl.ControllerServer
  alias Ctrl.Metronome
  alias Ctrl.TimeSeries
  alias Ctrl.TimeSeries.Dispatcher

  @doc """
  Entrypoint for the Ctrl (controller) application.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Dispatcher, [], restart: :permanent),
      worker(TimeSeries, [], restart: :permanent),
      worker(ControllerServer, [], restart: :permanent),
      worker(Metronome, [ControllerServer], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Ctrl]
    Supervisor.start_link(children, opts)
  end

end
