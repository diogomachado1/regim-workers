defmodule ImportMassive.MixProject do
  use Mix.Project

  def project do
    [
      app: :import_massive,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ImportMassive.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0"},
      {:ex_aws_sqs, "~> 3.2"},
      {:poison, "~> 3.0"},
      {:sweet_xml, "~> 0.6"},
      {:broadway_rabbitmq, "~> 0.6.1"},
      {:hackney, "~> 1.9"},
      {:jason, "~> 1.2"},
      {:remix, "~> 0.0.1", only: :dev},
      {:amqp, "~> 1.0"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
