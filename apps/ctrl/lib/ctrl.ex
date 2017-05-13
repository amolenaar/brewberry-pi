defmodule Ctrl do
  use Application

  @moduledoc false

  alias Ctrl.ControllerServer
  alias Ctrl.ControllerLoop
  alias Ctrl.Dispatcher
  alias Ctrl.Heater
  alias Ctrl.TimeSeries

  @heater_backend Application.get_env(:ctrl, :heater_backend)

  @doc """
  Entrypoint for the Ctrl (controller) application.

  Set the mash temperature with `Ctrl.MashTemperature.set!`.
  Read the actual state via `Ctrl.ControllerLoop.state?`.
  The controller can be switched on and off by calling
  `Ctrl.Controller.resume` and `pause`.
  """
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ControllerServer, [], restart: :permanent),
      worker(Heater, [@heater_backend], restart: :permanent),
      supervisor(Dispatcher, [], restart: :permanent),
      worker(TimeSeries, [], restart: :permanent),
      worker(ControllerLoop, [], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Ctrl]
    Supervisor.start_link(children, opts)
  end

end
