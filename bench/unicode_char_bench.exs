defmodule UnicodeCharBench do
  use Benchfella
  alias Unicode.Char

  @contents Path.join([__DIR__, "files", "text_data.txt"]) |> File.read!

  @is_lower_pat Regex.compile!(~S"\p{Ll}", "u")
  defp is_lower_regex(char) do
    Regex.match?(@is_lower_pat, char)
  end

  @is_upper_pat Regex.compile!(~S"\p{Lu}", "u")
  defp is_upper_regex(char) do
    Regex.match?(@is_upper_pat, char)
  end

  @is_digit_pat Regex.compile!(~S"\p{Nd}", "u")
  defp is_digit_regex(char) do
    Regex.match?(@is_digit_pat, char)
  end

  before_each_bench _ do
    {:ok, String.codepoints(@contents)}
  end

  bench "lower? regex version" do
    Enum.map(bench_context, &is_lower_regex/1)
  end

  bench "Char.lower?" do
    Enum.map(bench_context, &Char.lower?/1)
  end

  bench "upper? regex version" do
    Enum.map(bench_context, &is_upper_regex/1)
  end

  bench "Char.upper?" do
    Enum.map(bench_context, &Char.upper?/1)
  end

  bench "digit? regex version" do
    Enum.map(bench_context, &is_digit_regex/1)
  end

  bench "Char.digit?" do
    Enum.map(bench_context, &Char.digit?/1)
  end

end