defmodule Brewberry.FwRpi do
  use Application

  alias Nerves.Networking

  @interface :eth0

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Networking.Server, [@interface], id: @interface, restart: :permanent),
      # Add WLAN config
    ]

    opts = [strategy: :rest_for_one, name: Brewberry.FwPri]
    Supervisor.start_link(children, opts)
  end

end
