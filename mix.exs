defmodule Brewberry.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp deps do
    [
      {:credo, "~> 0.5.3", only: :dev, runtime: false},
      {:dialyxir, "~> 0.4", only: :dev, runtime: false}
    ]
  end
end
