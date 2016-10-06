defmodule ElixirQlib.Mixfile do
  use Mix.Project

  @version "0.1.1"

  def project do
    [app: :elixir_qlib,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     # Hex
     description: description(),
     package: package(),

     # Docs
     name: "Elixir QLib",
     docs: [source_ref: "v#{@version}", main: "Elixir QLib",
            canonical: "http://hexdocs.pm/elixir_qlib",
            source_url: "https://github.com/rhumbertgz/elixir_qlib"]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
    A simple queue abstraction library to support leasing and buffering in Elixir.
    """
  end

  defp package do
    [maintainers: ["Humberto Rodriguez Avila"],
     licenses: ["Apache 2.0"],
     links: %{"GitHub" => "https://github.com/rhumbertgz/elixir_qlib"},
     files: ~w(mix.exs README.md CHANGELOG.md lib)
    ]
  end
end
