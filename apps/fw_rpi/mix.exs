defmodule FwRpi.Mixfile do
  use Mix.Project

  #@target System.get_env("MIX_TARGET") || :host
  @target if Mix.env == :prod, do: :rpi, else: :host

  Mix.shell.info([:green, """
  Env
    MIX_ENV:  #{Mix.env}
    target:   #{@target}
  """, :reset])

  def project do
    [app: :fw_rpi,
     version: "0.1.0",
     elixir: "~> 1.5.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.6.1"],

     deps_path: "../../deps",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(@target),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application, do: application(@target)

  def application(:host) do
    [extra_applications: [:logger]]
  end
  def application(_target) do
    [mod: {FwRpi, []},
     extra_applications: [:logger]]
   end

  def deps do
    [{:nerves, "~> 0.7.5"},
     {:nerves_network, "~> 0.3.4"},
     {:nerves_firmware_http, "~> 0.4.1"},
     {:nerves_dnssd, "~> 0.1.0"},
     {:ctrl, in_umbrella: true},
     {:web, in_umbrella: true}]
  end

  def system(:host), do: []
  def system(target) do
    [{:nerves_runtime, "~> 0.4.4"},
     {:"nerves_system_#{target}", "~> 0.16.1", runtime: false}]
  end

  def aliases(:host), do: []
  def aliases(_target) do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
