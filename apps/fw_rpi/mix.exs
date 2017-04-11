defmodule FwRpi.Mixfile do
  use Mix.Project

  @target "rpi"

  def project do
    [app: :fw_rpi,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.3.1"],

     deps_path: "../../deps",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Brewberry.FwRpi, []},
     applications: [
       :logger,
       :nerves_networking,
       :ctrl,
       :web]]
  end

  def deps do
    [{:nerves, "~> 0.5.1"},
     {:nerves_networking, "~> 0.6.0", warn_missing: false},
     {:ctrl, in_umbrella: true},
     {:web, in_umbrella: true }]
  end

  def system do
    [{:nerves_runtime, "~> 0.1.0"},
     {:nerves_system_rpi, github: "amolenaar/nerves_system_rpi", branch: "8192cu"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
