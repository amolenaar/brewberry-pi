defmodule Brewberry.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp deps do
    [{:ex_doc, "~> 0.15.1", only: :dev, runtime: false},
     {:credo, "~> 0.7.4", only: :dev, runtime: false},
     {:dialyxir, "~> 0.4", only: :dev, runtime: false}]
  end
end
