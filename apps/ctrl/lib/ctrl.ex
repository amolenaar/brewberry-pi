defmodule Brewberry.Ctrl do
  use Application

  @moduledoc false

  alias Brewberry.ControllerServer
  alias Brewberry.ControllerLoop
  alias Brewberry.Dispatcher
  alias Brewberry.Heater
  alias Brewberry.TimeSeries

  @heater_backend Application.get_env(:ctrl, :heater_backend)

  @doc """
  Entrypoint for the Ctrl (controller) application.

  Set the mash temperature with `Brewberry.MashTemperature.set!`.
  Read the actual state via `Brewberry.ControllerLoop.state?`.
  The controller can be switched on and off by calling
  `Brewberry.Controller.resume` and `pause`.
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

    opts = [strategy: :one_for_one, name: Brewberry.Ctrl]
    Supervisor.start_link(children, opts)
  end

end
