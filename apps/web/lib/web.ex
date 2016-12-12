defmodule Brewberry.Web do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:web, :cowboy_port, 8080)

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Brewberry.Router, [], port: port)
    ]

    opts = [strategy: :one_for_one, name: Brewberry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
