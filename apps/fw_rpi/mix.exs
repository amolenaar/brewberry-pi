defmodule FwRpi.Mixfile do
  use Mix.Project

  @target System.get_env("MIX_TARGET") || :host
  #@target if Mix.env == :prod, do: :rpi, else: :host

  Mix.shell.info([:green, """
  Env
    MIX_ENV:  #{Mix.env}
    target:   #{@target}
  """, :reset])

  def project do
    [app: :fw_rpi,
     version: "0.1.0",
     elixir: "~> 1.5",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.7"],

     deps_path: "../../deps/#{@target}",
     build_path: "../../_build/#{@target}",
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
    [
      {:nerves, "~> 0.9.0"},
      {:nerves_runtime, "~> 0.4.4"},
      {:nerves_network, "~> 0.3.4"},
      {:nerves_firmware_http, "~> 0.4.1"},
      #{:nerves_dnssd, "~> 0.1.0"},
      {:nerves_dnssd, github: "amolenaar/nerves_dnssd"},
      {:shoehorn, "~> 0.2"},
      {:ctrl, in_umbrella: true},
      {:web, in_umbrella: true}
    ]
  end

  def system(:host), do: []
  def system("rpi3") do
    [{:nerves_system_rpi3, "~> 0.20.0", runtime: false}]
  end
  def system("rpi2") do
    [{:nerves_system_rpi2, "~> 0.20.0", runtime: false}]
  end
  def system("rpi0") do
    [{:nerves_system_rpi0, "~> 0.20.0", runtime: false}]
  end
  def system("rpi") do
    [{:nerves_system_rpi, "~> 0.20.0", runtime: false}]
  end

  def aliases(:host), do: []
  def aliases(_target) do
    [
      # add custom mix aliases here
    ] |> Nerves.Bootstrap.add_aliases()
  end

end
