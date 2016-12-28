defmodule Brewberry.Ctrl do
  use Application

  @moduledoc false

  alias Brewberry.Controller
  alias Brewberry.ControllerLoop
  alias Brewberry.Heater
  alias Brewberry.MashTemperature
  alias Brewberry.Measure

  @measure_backend Application.get_env(:ctrl, :measure_backend)
  @heater_backend Application.get_env(:ctrl, :heater_backend)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ControllerLoop, [], restart: :permanent),
      worker(Measure, [@measure_backend], restart: :permanent),
      worker(MashTemperature, [], restart: :permanent),
      worker(Controller, [], restart: :permanent),
      worker(Heater, [@heater_backend], restart: :permanent),
    ]

    opts = [strategy: :rest_for_one, name: Brewberry.Ctrl]
    Supervisor.start_link(children, opts)
  end
end
