defmodule Pastry.Mixfile do
  use Mix.Project

  def project do
    [
      app: :project3,
      version: "0.1.0",
      #elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      escript: [main_module: Pastry,
                emu_args: [ "+P 5000000" ]
                ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
