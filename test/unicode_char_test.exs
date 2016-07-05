defmodule Unicode.CharTest do
  use ExUnit.Case
  alias Unicode.Char
  
  doctest Unicode.Char

  test "lower?" do
    refute Char.lower?("A")
    refute Char.lower?("È")
    refute Char.lower?("Ç")
    refute Char.lower?("4")
    refute Char.lower?("%")
    refute Char.lower?("#")
    refute Char.lower?(" ")
    
    assert Char.lower?("б")
    assert Char.lower?("ß")
    assert Char.lower?("ﬁ")
  end
  
  test "upper?" do
    assert Char.upper?("A")
    assert Char.upper?("È")
    assert Char.upper?("Ç")
    refute Char.upper?("4")
    refute Char.upper?("%")
    refute Char.upper?("#")
    refute Char.upper?(" ")
    
    refute Char.upper?("б")
    refute Char.upper?("ß")
    refute Char.upper?("ﬁ")
    refute Char.upper?("\u1F8D") # it's title
  end
  
  test "digit?" do
    assert Char.digit?("1")
    assert Char.digit?("0")
    assert Char.digit?("9")
    assert Char.digit?("៣") # KHMER DIGIT THREE
    refute Char.digit?("A")
    refute Char.digit?("b")
    refute Char.digit?("Я")
    refute Char.digit?("ß")
    refute Char.digit?("22")
  end
  
  test "control?" do
    assert Char.control?(<<10>>) # \n
    assert Char.control?(<<13>>) # \r
    assert Char.control?(<<0x0007>>) # BELL
    assert Char.control?(<<0x007F>>) # DELETE
    assert Char.control?(<<0x009C :: utf8>>) # STRING TERMINATOR
    
    refute Char.control?("b")
    refute Char.control?("Я")
    refute Char.control?("ß")
    refute Char.control?("22")
  end
  
  test "whitespace?" do
    assert Char.whitespace?(<<9>>) # CHARACTER TAB
    assert Char.whitespace?(<<10 :: utf8>>) # \n
    assert Char.whitespace?(<<13 :: utf8>>) # \r
    assert Char.whitespace?(" ") # SPACE
    assert Char.whitespace?("\u2008") # PUNCTATION SPACE
    assert Char.whitespace?("\u2028") # LINE SEPARATOR
    assert Char.whitespace?("\u2029") # PARAGRAPH SEPARATOR
    
    refute Char.whitespace?("b")
    refute Char.whitespace?("Я")
    refute Char.whitespace?("ß")
    refute Char.whitespace?("9")
    refute Char.whitespace?("#")
    refute Char.whitespace?(")")
  end

end
