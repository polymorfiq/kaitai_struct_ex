defmodule KaitaiStruct do
  @moduledoc """
  `KaitaiStruct` is the Elixir runtime for Kaitai
  """

  @native_encoding :utf8
  @encodings %{
    "UTF-8" => :utf8,
    "UTF-16" => :utf16,
    "UTF-16BE" => {:utf16, :big},
    "UTF-16LE" => {:utf16, :little},
    "UTF-32" => :utf32
  }

  @spec native_encoding() :: :utf8
  @doc "Elixir strings will be assumed to be encoded in UTF-8 format unless otherwise specified"
  def native_encoding, do: @native_encoding

  @doc """
  Currently accepted encodings:
  - UTF-8
  - UTF-16
  - UTF-16LE
  - UTF-16BE
  - UTF-32
  """
  @spec encodings() :: map()
  def encodings, do: @encodings

  @doc "Takes a binary and returns a new binary with the occurrences of the matching byte stripped from the end"
  @spec bytes_strip_right(bytes :: binary(), pad_byte :: integer()) :: binary()
  def bytes_strip_right(bytes, pad_byte) do
    String.trim_trailing(bytes, <<pad_byte::integer>>)
  end

  @doc "Searches binary for the term and if found, returns a binary terminated at that location. If not found, returns input binary"
  @spec bytes_terminate(bytes :: binary(), term :: integer(), include_term :: boolean()) ::
          binary()
  def bytes_terminate(bytes, term, include_term) do
    terminated = Enum.take_while(:binary.bin_to_list(bytes), &(&1 != term))

    cond do
      Enum.count(terminated) == byte_size(bytes) ->
        bytes

      include_term ->
        <<:binary.list_to_bin(terminated)::binary, term::integer>>

      true ->
        :binary.list_to_bin(terminated)
    end
  end

  @doc "Takes a binary and specifies its' encoding"
  @spec bytes_to_str(bytes :: binary(), encoding :: String.t()) ::
          {:ok, binary()} | {:error, :unsupported_encoding} | {:error, {:encoding_error, term()}}
  def bytes_to_str(bytes, encoding) do
    if encoding = Map.get(encodings(), encoding) do
      case :unicode.characters_to_binary(bytes, encoding) do
        resp when is_binary(resp) -> {:ok, resp}
        unexpected -> {:error, {:encoding_error, unexpected}}
      end
    else
      {:error, :unsupported_encoding}
    end
  end

  @doc "Takes a binary and specifies its' encoding. Raises exception in the case of failure"
  @spec bytes_to_str!(bytes :: binary(), encoding :: String.t()) :: String.t()
  def bytes_to_str!(bytes, encoding) do
    {:ok, str} = bytes_to_str(bytes, encoding)
    str
  end

  @doc "Runs modulo on inputs"
  @spec mod(a :: integer(), b :: integer()) :: integer()
  def mod(a, b), do: rem(a, b)
end
