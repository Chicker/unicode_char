defmodule Unicode.Char.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :unicode_char,
     version: @version,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps(),
     description: description(),
     package: package()
     ]
  end

  def application do
    [applications: []]
  end

  defp description do
    """
    In this library are implemented functions (Char.lower?, Char.digit?, etc)
    to work with Unicode characters, which are is missing in the stdlib.
    """
  end

  defp package do
    [
      files:       [ "lib", "mix.exs", "README.md", "LICENSE", "VERSION",
                    "CHANGES"
                   ],
      maintainers: [ "Vadim Agishev (Chicker) <vadim.agishev@gmail.com>"],
      licenses:    [ "Same as Elixir" ],
      links:       %{
                       "GitHub" => "https://github.com/Chicker/unicode_char"
                   }
    ]
  end
  
  defp deps do
    [{:benchfella, "~> 0.3.2", only: :dev }
    ]
  end

  defp elixirc_paths(_), do: ["lib"]
end
