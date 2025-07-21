defmodule KaitaiStruct.MixProject do
  use Mix.Project

  def project do
    [
      app: :kaitai_struct,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      licenses: ["MIT"],
      links: %{
        "github": "https://github.com/polymorfiq/kaitai_struct_ex"
      },
      source_url: "https://github.com/polymorfiq/kaitai_struct_ex",
      homepage_url: "https://github.com/polymorfiq/kaitai_struct_ex/"
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
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
