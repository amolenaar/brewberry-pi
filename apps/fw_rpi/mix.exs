defmodule FwRpi.Mixfile do
  use Mix.Project

  @target "rpi"

  def project do
    [app: :fw_rpi,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "../../deps/#{@target}",
     build_path: "../../_build/#{@target}",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Brewberry.FwRpi, []},
     applications: [
       :logger,
       :nerves_networking,
       :nerves_interim_wifi,
       :ctrl,
       :web,
       :poison]]
  end

  def deps do
    [{:nerves, "~> 0.4.0"},
     {:nerves_networking, "~> 0.6.0"},
     {:nerves_interim_wifi, "~> 0.1.0"},
     {:ctrl, in_umbrella: true},
     {:web, in_umbrella: true }]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
