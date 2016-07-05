to_binary = fn
  "" ->
    nil
  codepoints ->
    codepoints
    |> :binary.split(" ", [:global])
    |> Enum.map(&<<String.to_integer(&1, 16)::utf8>>)
    |> IO.iodata_to_binary
end

data_path = Path.join([__DIR__, "files", "UnicodeData.txt"])

{codes, non_breakable, decompositions, combining_classes, digits, control_chars,
  whitespace} =
    Enum.reduce File.stream!(data_path),
                          {[], [], %{}, %{}, [], [], []}, fn line, {cacc,
                                        wacc, dacc, kacc, nacc, ccacc, wsacc} ->
      [codepoint, _name, category,
       class, _bidi, decomposition,
       _numeric_1, _numeric_2, _numeric_3,
       _bidi_mirror, _unicode_1, _iso,
       upper, lower, title] = :binary.split(line, ";", [:global])

      title = :binary.part(title, 0, byte_size(title) - 1)

      cacc =
        if upper != "" or lower != "" or title != "" do
          [{to_binary.(codepoint), to_binary.(upper), to_binary.(lower), to_binary.(title)} | cacc]
        else
          cacc
        end

      wacc =
        case decomposition do
          "<noBreak>" <> _ -> [to_binary.(codepoint) | wacc]
          _ -> wacc
        end

      dacc =
        case decomposition do
          <<h, _::binary>> when h != ?< -> # Decomposition
            decomposition =
              decomposition
              |> :binary.split(" ", [:global])
              |> Enum.map(&String.to_integer(&1, 16))
            Map.put(dacc, String.to_integer(codepoint, 16), decomposition)
          _ ->
            dacc
        end

      kacc =
        case Integer.parse(class) do
          {0, ""} -> kacc
          {n, ""} -> Map.put(kacc, String.to_integer(codepoint, 16), n)
        end

      # decimal digits
      nacc =
        if category == "Nd" do
          [{to_binary.(codepoint)} | nacc]
        else
          nacc
        end
      
      # control characters
      ccacc =
        if category == "Cc" do
          [{to_binary.(codepoint)} | ccacc]
        else
          ccacc
        end

      # whitespace chars
      wsacc =
        if category in ["Zs", "Zl", "Zp"] do
          [to_binary.(codepoint) | wsacc]
        else
          wsacc
        end

      {cacc, wacc, dacc, kacc, nacc, ccacc, wsacc}
    end

defmodule Unicode.Char do
  
  @moduledoc false

  special_path = Path.join([__DIR__, "files", "SpecialCasing.txt"])

  codes = Enum.reduce File.stream!(special_path), codes, fn line, acc ->
    [codepoint, lower, title, upper, _] = :binary.split(line, "; ", [:global])
    key = to_binary.(codepoint)
    :lists.keystore(key, 1, acc, {key,
                                  to_binary.(upper),
                                  to_binary.(lower),
                                  to_binary.(title)})
  end

  # not included in UnicodeData.txt
  whitespace = whitespace ++ Enum.map(["9", "A", "B", "C", "D", "85"], &to_binary.(&1))

  for {<<char :: utf8>>, upper, lower, title} <- codes do
    def get_codepoint_info(unquote(char))
      when is_nil(unquote(lower)) or unquote(<<char :: utf8>>) == unquote(lower) do
        %{case: :lower, upper: unquote(upper),
                        lower: unquote(<<char :: utf8>>),
                        title: unquote(title)}
    end

    def get_codepoint_info(unquote(char)) when is_nil(unquote(upper)) do
      %{case: :upper, upper: unquote(<<char :: utf8>>),
                      lower: unquote(lower),
                      title: unquote(title)}
    end
  end
  
  def get_codepoint_info(_), do: %{}

  # lower

  def lower?(<<char :: utf8>>) do
    case get_codepoint_info(char) do
      %{case: :lower} -> true
      _ -> false
    end
  end

  # upper

  def upper?(<<char :: utf8>>) do
    case get_codepoint_info(char) do
      %{case: :upper} -> true
      _ -> false
    end
  end

  # decimal digit

  for {digit} <- digits do
    def digit?(unquote(digit)), do: true
  end

  def digit?(_), do: false

  # control char

  for {cchar} <- control_chars do
    def control?(unquote(cchar)), do: true
  end

  def control?(_), do: false

  # whitespace

  for codepoint <- whitespace do
    def whitespace?(unquote(codepoint)), do: true
  end

  def whitespace?(_), do: false

  # letter

  @is_letter_pat Regex.compile!(~S"\p{Ll}|\p{Lu}|\p{Lt}|\p{Lm}|\p{Lo}", "u")
  def letter?(char) do
    Regex.match?(@is_letter_pat, char)
  end

end