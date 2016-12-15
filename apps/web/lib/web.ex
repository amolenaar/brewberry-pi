defmodule Brewberry.Web do
  use Application

  @moduledoc false

  alias Brewberry.Router
  alias Plug.Adapters.Cowboy

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:web, :cowboy_port, 8080)

    children = [
      Cowboy.child_spec(:http, Router, [], port: port)
    ]

    opts = [strategy: :one_for_one, name: Brewberry.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
