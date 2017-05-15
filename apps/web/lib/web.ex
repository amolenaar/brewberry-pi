defmodule Web do
  use Application

  @moduledoc false

  alias Web.Router
  alias Plug.Adapters.Cowboy

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    port = Application.get_env(:web, :port)

    children = [
      Cowboy.child_spec(:http, Router, [], port: port, acceptors: 10)
    ]

    opts = [strategy: :one_for_one, name: Web]
    Supervisor.start_link(children, opts)
  end
end
