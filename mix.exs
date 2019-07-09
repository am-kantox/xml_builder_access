defmodule Iso20022.MixProject do
  use Mix.Project

  @app :xml_builder_access
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      package: package(),
      aliases: aliases(),
      deps: deps(),
      description: "Access implementation for XmlBuilder.",
      name: "XmlBuilder.Access",
      xref: [exclude: []],
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, ".dialyzer/plts/dialyzer.plt"},
        ignore_warnings: ".dialyzer/ignore.exs"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      quality: ["format", "credo --strict", "dialyzer", "test"],
      "quality.ci": [
        "test",
        "format --check-formatted",
        "credo --strict",
        "dialyzer --halt-exit-status"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xml_builder, "~> 2.0"},
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:earmark, ">= 0.0.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      files: ~w(lib .formatter.exs .dialyzer/ignore.exs mix.exs README*),
      maintainers: ["Aleksei Matiushkin"],
      licenses: ["Kantox LTD"],
      links: %{"GitHub" => "https://github.com/am-kantox/#{@app}"}
    ]
  end

  defp docs() do
    [
      main: "XmlBuilder.Access",
      source_ref: "v#{@version}",
      source_url: "https://github.com/am-kantox/#{@app}",
      canonical: "http://hexdocs.pm/#{@app}",
      extras: ["README.md"],
      groups_for_modules: []
    ]
  end
end
