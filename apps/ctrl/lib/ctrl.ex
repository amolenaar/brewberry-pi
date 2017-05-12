defmodule Brewberry.Ctrl do
  use Application

  @moduledoc false

  alias Brewberry.Controller
  alias Brewberry.ControllerLoop
  alias Brewberry.Dispatcher
  alias Brewberry.Heater
  alias Brewberry.MashTemperature
  alias Brewberry.Measure
  alias Brewberry.TimeSeries

  @measure_backend Application.get_env(:ctrl, :measure_backend)
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
      worker(Measure, [@measure_backend], restart: :permanent),
      worker(MashTemperature, [], restart: :permanent),
      worker(Controller, [], restart: :permanent),
      worker(Heater, [@heater_backend], restart: :permanent),
      supervisor(Dispatcher, [], restart: :permanent),
      worker(TimeSeries, [], restart: :permanent),
      worker(ControllerLoop, [], restart: :permanent)
    ]

    opts = [strategy: :one_for_one, name: Brewberry.Ctrl]
    Supervisor.start_link(children, opts)
  end

end
