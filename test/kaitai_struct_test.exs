defmodule KaitaiStructTest do
  use ExUnit.Case
  doctest KaitaiStruct

  test "bytes_strip_right/2 correctly strips right-hand-side of binary" do
    assert <<0xFF, 0xAA, 0xBB>> = KaitaiStruct.bytes_strip_right(<<0xFF, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>>, 0xCC)
    assert <<0xFF, 0xCC, 0xAA, 0xBB>> = KaitaiStruct.bytes_strip_right(<<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>>, 0xCC)
    assert <<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC, 0xAA>> = KaitaiStruct.bytes_strip_right(<<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC, 0xAA>>, 0xCC)
    assert <<>> = KaitaiStruct.bytes_strip_right(<<>>, 0xCC)
  end

  test "bytes_terminate/3 correctly terminates string" do
    assert <<0xFF, 0xAA, 0xBB>> = KaitaiStruct.bytes_terminate(<<0xFF, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>>, 0xCC, false)
    assert <<0xFF, 0xAA, 0xBB, 0xCC>> = KaitaiStruct.bytes_terminate(<<0xFF, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>>, 0xCC, true)
    assert <<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>> = KaitaiStruct.bytes_terminate(<<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC>>, 0xDD, false)
    assert <<0xFF, 0xCC, 0xAA>> = KaitaiStruct.bytes_terminate(<<0xFF, 0xCC, 0xAA, 0xBB, 0xCC, 0xCC, 0xCC, 0xAA>>, 0xAA, true)
    assert <<>> = KaitaiStruct.bytes_terminate(<<>>, 0xCC, false)
    assert <<>> = KaitaiStruct.bytes_terminate(<<>>, 0xCC, true)
  end

  test "bytes_to_str/2 correctly re-encodes bytes to native string" do
    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf8)
    assert {:ok, "Hello, world!"} = KaitaiStruct.bytes_to_str(encoded, "UTF-8")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, {:utf16, :little})
    assert {:ok, "Hello, world!"} = KaitaiStruct.bytes_to_str(encoded, "UTF-16LE")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, {:utf16, :big})
    assert {:ok, "Hello, world!"} = KaitaiStruct.bytes_to_str(encoded, "UTF-16BE")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf16)
    assert {:ok, "Hello, world!"} = KaitaiStruct.bytes_to_str(encoded, "UTF-16")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf32)
    assert {:ok, "Hello, world!"} = KaitaiStruct.bytes_to_str(encoded, "UTF-32")
  end

  test "bytes_to_str/2 handles errors correctly" do
    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf16)
    assert {:error, :unsupported_encoding} = KaitaiStruct.bytes_to_str(encoded, "UTF-NONSENSE")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf16)
    assert {:error, {:encoding_error, _}} = KaitaiStruct.bytes_to_str(encoded, "UTF-32")

    encoded = :unicode.characters_to_binary("Hello, world!", :unicode, :utf8)
    assert {:error, {:encoding_error, _}} = KaitaiStruct.bytes_to_str(encoded, "UTF-16")
  end
end
