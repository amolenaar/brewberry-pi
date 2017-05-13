defmodule Web do
  use Application

  @moduledoc false

  alias Web.Router
  alias Plug.Adapters.Cowboy

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:web, :cowboy_port, 8080)

    children = [
      Cowboy.child_spec(:http, Router, [], port: port, acceptors: 10),
      worker(Task, [fn -> Ctrl.ControllerLoop.run_infinite! end])
    ]

    opts = [strategy: :one_for_one, name: Brewberry.Web]
    Supervisor.start_link(children, opts)
  end
end
