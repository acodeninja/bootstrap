defmodule MixProject do
  use Mix.Project

  def project do
    [
      app: :{{PROJECT_SNAKE}},
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: ["src"],
      start_permanent: Mix.env() == :prod,
      lockfile: "/cache/mix.lock",
      deps: deps()
    ]
  end

  def application do
    [extra_applications: []]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: :dev, runtime: false}
    ]
  end
end
