defmodule Web.Mixfile do
  use Mix.Project

  def project do
    [app: :web,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:cowboy, :logger, :plug, :plug_redirect],
    mod: {Brewberry.Web, []},
    env: [cowboy_port: 8080]]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.3.0"},
      {:plug_redirect, "~> 0.0"},
      {:poison, "~> 3.0"}
    ]
  end
end
