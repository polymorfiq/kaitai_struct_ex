defmodule KaitaiStruct.MixProject do
  use Mix.Project

  def project do
    [
      app: :kaitai_struct,
      version: "0.1.10",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: [
        description:
          "Kaitai Struct is a declarative language used for describe various binary data structures, laid out in files or in memory: i.e. binary file formats, network stream packet formats, etc.",
        licenses: ["MIT"],
        links: %{
          "github" => "https://github.com/polymorfiq/kaitai_struct_ex"
        },
        source_url: "https://github.com/polymorfiq/kaitai_struct_ex",
        homepage_url: "https://github.com/polymorfiq/kaitai_struct_ex/"
      ]
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
