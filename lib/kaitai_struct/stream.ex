defmodule KaitaiStruct.Stream do
  @moduledoc """
  Interface for streaming data of known size

  Implements the functions mentioned in the [Kaitai Runtime Specification](https://github.com/kaitai-io/kaitai_struct/tree/216acdec97d16b10d331ba9245366b60a69486d4/runtime), implementing the [Kaitai Stream API](https://doc.kaitai.io/stream_api.html)
  """

  use GenServer
  require Record

  defmodule ReadError do
    defexception [:message]
  end

  Record.defrecordp(:stream_state, stream: nil, size_bits: nil, pos_bits: 0, buffer: <<>>)

  @type t :: pid()
  @type stream_state ::
          record(:stream_state,
            stream: Enumerable.t(),
            size_bits: non_neg_integer(),
            pos_bits: non_neg_integer(),
            buffer: binary()
          )

  @type read_error() :: :reached_eof

  @impl true
  def init({stream, size}), do: {:ok, stream_state(stream: stream, size_bits: size * 8)}

  @doc "Given a filename, attempts to generate a `KaitaiStruct.Stream` or raises an exception"
  @spec from_file!(path :: Path.t(), parse :: fun()) :: term()
  def from_file!(path, parse) do
    stat = File.stat!(path)

    File.open!(path, [:read], fn file ->
      io = IO.binstream(file, 1)
      {:ok, stream} = GenServer.start_link(KaitaiStruct.Stream, {io, stat.size})

      parse.(stream)
    end)
  end

  @doc "`true` if the stream has emitted its final byte, `false` otherwise"
  @spec eof?(stream :: pid()) :: boolean()
  def eof?(pid), do: GenServer.call(pid, :eof?)

  @doc "Moves the stream position forward by `n` bytes, or to the end of the stream. Whichever is smaller."
  @spec seek(stream :: pid(), n :: non_neg_integer()) ::
          :ok | {:error, :reached_eof} | {:error, :cannot_seek_backwards}
  def seek(pid, n), do: GenServer.call(pid, {:seek, n})

  @doc "Current position (bytes read) within the stream"
  @spec pos(stream :: pid()) :: non_neg_integer()
  def pos(pid), do: GenServer.call(pid, :pos)

  @doc "Total size of the stream, in bytes"
  @spec size(stream :: pid()) :: non_neg_integer()
  def size(pid), do: GenServer.call(pid, :size)

  @doc "Read signed integer (1 byte) from stream."
  @spec read_s1(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s1(pid), do: GenServer.call(pid, {:read, :signed_integer, 1})

  @doc "Read signed integer (1 byte) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s1!(stream :: pid()) :: integer()
  def read_s1!(pid), do: read_s1(pid) |> respond_or_raise!()

  @doc "Read signed integer (2 bytes, big-endian) from stream."
  @spec read_s2be(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s2be(pid), do: GenServer.call(pid, {:read, :signed_integer_be, 2})

  @doc "Read signed integer (2 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s2be!(stream :: pid()) :: integer()
  def read_s2be!(pid), do: read_s2be(pid) |> respond_or_raise!()

  @doc "Read signed integer (4 bytes, big-endian) from stream."
  @spec read_s4be(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s4be(pid), do: GenServer.call(pid, {:read, :signed_integer_be, 4})

  @doc "Read signed integer (4 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s4be!(stream :: pid()) :: integer()
  def read_s4be!(pid), do: read_s4be(pid) |> respond_or_raise!()

  @doc "Read signed integer (8 bytes, big-endian) from stream."
  @spec read_s8be(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s8be(pid), do: GenServer.call(pid, {:read, :signed_integer_be, 8})

  @doc "Read signed integer (8 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s8be!(stream :: pid()) :: integer()
  def read_s8be!(pid), do: read_s8be(pid) |> respond_or_raise!()

  @doc "Read signed integer (2 bytes, little-endian) from stream."
  @spec read_s2le(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s2le(pid), do: GenServer.call(pid, {:read, :signed_integer_le, 2})

  @doc "Read signed integer (2 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s2le!(stream :: pid()) :: integer()
  def read_s2le!(pid), do: read_s2le(pid) |> respond_or_raise!()

  @doc "Read signed integer (4 bytes, little-endian) from stream."
  @spec read_s4le(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s4le(pid), do: GenServer.call(pid, {:read, :signed_integer_le, 4})

  @doc "Read signed integer (4 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s4le!(stream :: pid()) :: integer()
  def read_s4le!(pid), do: read_s4le(pid) |> respond_or_raise!()

  @doc "Read signed integer (8 bytes, little-endian) from stream."
  @spec read_s8le(stream :: pid()) :: {:ok, integer()} | {:error, read_error()}
  def read_s8le(pid), do: GenServer.call(pid, {:read, :signed_integer_le, 8})

  @doc "Read signed integer (8 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_s8le!(stream :: pid()) :: integer()
  def read_s8le!(pid), do: read_s8le(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (1 byte) from stream."
  @spec read_u1(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u1(pid), do: GenServer.call(pid, {:read, :unsigned_integer, 1})

  @doc "Read unsigned integer (1 byte) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u1!(stream :: pid()) :: non_neg_integer()
  def read_u1!(pid), do: read_u1(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (2 bytes, big-endian) from stream."
  @spec read_u2be(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u2be(pid), do: GenServer.call(pid, {:read, :unsigned_integer_be, 2})

  @doc "Read unsigned integer (2 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u2be!(stream :: pid()) :: non_neg_integer()
  def read_u2be!(pid), do: read_u2be(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (4 bytes, big-endian) from stream."
  @spec read_u4be(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u4be(pid), do: GenServer.call(pid, {:read, :unsigned_integer_be, 4})

  @doc "Read unsigned integer (4 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u4be!(stream :: pid()) :: non_neg_integer()
  def read_u4be!(pid), do: read_u4be(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (8 bytes, big-endian) from stream."
  @spec read_u8be(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u8be(pid), do: GenServer.call(pid, {:read, :unsigned_integer_be, 8})

  @doc "Read unsigned integer (8 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u8be!(stream :: pid()) :: non_neg_integer()
  def read_u8be!(pid), do: read_u8be(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (2 bytes, little-endian) from stream."
  @spec read_u2le(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u2le(pid), do: GenServer.call(pid, {:read, :unsigned_integer_le, 2})

  @doc "Read unsigned integer (2 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u2le!(stream :: pid()) :: non_neg_integer()
  def read_u2le!(pid), do: read_u2le(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (4 bytes, little-endian) from stream."
  @spec read_u4le(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u4le(pid), do: GenServer.call(pid, {:read, :unsigned_integer_le, 4})

  @doc "Read unsigned integer (4 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u4le!(stream :: pid()) :: non_neg_integer()
  def read_u4le!(pid), do: read_u4le(pid) |> respond_or_raise!()

  @doc "Read unsigned integer (8 bytes, little-endian) from stream."
  @spec read_u8le(stream :: pid()) :: {:ok, non_neg_integer()} | {:error, read_error()}
  def read_u8le(pid), do: GenServer.call(pid, {:read, :unsigned_integer_le, 8})

  @doc "Read unsigned integer (8 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_u8le!(stream :: pid()) :: non_neg_integer()
  def read_u8le!(pid), do: read_u8le(pid) |> respond_or_raise!()

  @doc "Read float (4 bytes, big-endian) from stream."
  @spec read_f4be(stream :: pid()) :: {:ok, float()} | {:error, read_error()}
  def read_f4be(pid), do: GenServer.call(pid, {:read, :float_be, 4})

  @doc "Read float (4 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_f4be!(stream :: pid()) :: float()
  def read_f4be!(pid), do: read_f4be(pid) |> respond_or_raise!()

  @doc "Read float (8 bytes, big-endian) from stream."
  @spec read_f8be(stream :: pid()) :: {:ok, float()} | {:error, read_error()}
  def read_f8be(pid), do: GenServer.call(pid, {:read, :float_be, 8})

  @doc "Read float (8 bytes, big-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_f8be!(stream :: pid()) :: float()
  def read_f8be!(pid), do: read_f8be(pid) |> respond_or_raise!()

  @doc "Read float (4 bytes, little-endian) from stream."
  @spec read_f4le(stream :: pid()) :: {:ok, float()} | {:error, read_error()}
  def read_f4le(pid), do: GenServer.call(pid, {:read, :float_le, 4})

  @doc "Read float (4 bytes, little-endian) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_f4le!(stream :: pid()) :: float()
  def read_f4le!(pid), do: read_f4le(pid) |> respond_or_raise!()

  @doc "Read float (8 bytes, little-endian) from stream."
  @spec read_f8le(stream :: pid()) :: {:ok, float()} | {:error, read_error()}
  def read_f8le(pid), do: GenServer.call(pid, {:read, :float_le, 8})

  @doc "Read float (8 bytes, little-endian) from stream."
  @spec read_f8le!(stream :: pid()) :: float()
  def read_f8le!(pid), do: read_f8le(pid) |> respond_or_raise!()

  @doc "Re-align to bytes after moving to an non-standard bit alignment"
  @spec align_to_byte(stream :: pid()) :: :ok
  def align_to_byte(pid), do: GenServer.cast(pid, :align_to_byte)

  @doc "Read an integer (little-endian, composed of N bits) from stream."
  @spec read_bits_int_le(stream :: pid(), n :: non_neg_integer()) ::
          {:ok, integer()} | {:error, read_error()}
  def read_bits_int_le(pid, n), do: GenServer.call(pid, {:read, {:bit_int, :little}, n})

  @doc "Read an integer (little-endian, composed of N bits) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_bits_int_le!(stream :: pid(), n :: non_neg_integer()) :: integer()
  def read_bits_int_le!(pid, n), do: read_bits_int_le(pid, n) |> respond_or_raise!()

  @doc "Read an integer (big-endian, composed of N bits) from stream."
  @spec read_bits_int_be(stream :: pid(), n :: non_neg_integer()) ::
          {:ok, integer()} | {:error, read_error()}
  def read_bits_int_be(pid, n), do: GenServer.call(pid, {:read, {:bit_int, :big}, n})

  @doc "Read an integer (big-endian, composed of N bits) from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_bits_int_be!(stream :: pid(), n :: non_neg_integer()) :: integer()
  def read_bits_int_be!(pid, n), do: read_bits_int_be(pid, n) |> respond_or_raise!()

  @doc "Read an array of `n` bits from stream."
  @spec read_bits_array(stream :: pid(), n :: non_neg_integer()) ::
          {:ok, [boolean()]} | {:error, read_error()}
  def read_bits_array(pid, n), do: GenServer.call(pid, {:read, :bit_array, n})

  @doc "Read an array of `n` bits from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_bits_array!(stream :: pid(), n :: non_neg_integer()) :: [boolean()]
  def read_bits_array!(pid, n), do: read_bits_array(pid, n) |> respond_or_raise!()

  @doc "An array of `n` bytes from stream."
  @spec read_bytes_array(stream :: pid(), n :: non_neg_integer()) ::
          {:ok, binary()} | {:error, read_error()}
  def read_bytes_array(pid, n), do: GenServer.call(pid, {:read, :byte_array, n})

  @doc "An array of `n` bytes from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_bytes_array!(stream :: pid(), n :: non_neg_integer()) :: binary()
  def read_bytes_array!(pid, n), do: read_bytes_array(pid, n) |> respond_or_raise!()

  @doc "An array of all remaining bytes from stream."
  @spec read_bytes_full(stream :: pid()) :: {:ok, binary()} | {:error, read_error()}
  def read_bytes_full(pid), do: GenServer.call(pid, {:read, :byte_array_full})

  @doc "An array of all remaining bytes from stream. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec read_bytes_full!(stream :: pid()) :: binary()
  def read_bytes_full!(pid), do: read_bytes_full(pid) |> respond_or_raise!()

  @doc """
  Read bytes until the character (in the given encoding) is reached. Accepted encodings at `KaitaiStruct.encodings/0`
  """
  @spec read_bytes_term(
          stream :: pid(),
          encoding :: String.t(),
          term :: integer(),
          include_term :: boolean(),
          consume_term :: boolean(),
          eos_error :: boolean()
        ) ::
          {:ok, binary()}
          | {:error, read_error()}
          | {:error, :unsupported_encoding}
          | {:error, {:term_encoding_error, term()}}
  def read_bytes_term(pid, encoding, term, include_term, consume_term, eos_error) do
    if encoding = Map.get(KaitaiStruct.encodings(), encoding) do
      case :unicode.characters_to_binary(term, KaitaiStruct.native_encoding(), encoding) do
        term_bin when is_binary(term_bin) ->
          GenServer.call(
            pid,
            {:read, {:bytes_term, term_bin, include_term, consume_term, eos_error}}
          )

        unexpected ->
          {:error, {:term_encoding_error, unexpected}}
      end
    else
      {:error, :unsupported_encoding}
    end
  end

  @doc """
  Read bytes until the character (in the given encoding) is reached. Accepted encodings at `KaitaiStruct.encodings/0`
  Raises `KaitaiStruct.Stream.ReadError` on failure.
  """
  @spec read_bytes_term!(
          stream :: pid(),
          encoding :: String.t(),
          term :: integer(),
          include_term :: boolean(),
          consume_term :: boolean(),
          eos_error :: boolean()
        ) :: binary()
  def read_bytes_term!(pid, encoding, term, include_term, consume_term, eos_error) do
    read_bytes_term(pid, encoding, term, include_term, consume_term, eos_error)
    |> respond_or_raise!()
  end

  @doc "Takes a list of bytes and ensures that the next bytes in the stream are an exact match"
  @spec ensure_fixed_contents(stream :: pid(), contents :: binary()) ::
          :ok | {:error, read_error()} | {:error, {:fixed_contents_mismatch, integer(), String.t()}}
  def ensure_fixed_contents(pid, contents) do
    GenServer.call(pid, {:ensure, {:fixed_contents, contents}})
  end

  @doc "Takes a list of bytes and ensures that the next bytes in the stream are an exact match. Raises `KaitaiStruct.Stream.ReadError` on failure"
  @spec ensure_fixed_contents!(stream :: pid(), contents :: binary()) :: :ok
  def ensure_fixed_contents!(pid, contents),
    do: ensure_fixed_contents(pid, contents) |> respond_or_raise!()

  @spec repeat(stream :: pid(), until_cond :: :eos, read_fn :: fun()) :: [term()]
  def repeat(pid, :eos, data_fn, idx \\ 0) do
    if eof?(pid), do: [], else: [data_fn.(pid, idx) | repeat(pid, :eos, data_fn, idx + 1)]
  end

  defp respond_or_raise!(resp) do
    case resp do
      :ok ->
        :ok

      {:ok, data} ->
        data

      {:error, {:fixed_contents_mismatch, pos, message}} ->
        raise ReadError, message: "Fixed Content Mismatch as byte #{pos}: #{message}"

      {:error, err} ->
        raise ReadError, message: "Error occurred while reading stream: #{inspect(err)}"
    end
  end

  @impl true
  def handle_call(:eof?, _from, state),
    do: {:reply, stream_state(state, :pos_bits) == stream_state(state, :size_bits), state}

  @impl true
  def handle_call(:pos, _from, state),
    do: {:reply, stream_state(state, :pos_bits) / 8, state}

  @impl true
  def handle_call(:size, _from, state),
    do: {:reply, stream_state(state, :size_bits) / 8, state}

  @impl true
  def handle_call({:read, :signed_integer, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::signed-integer-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :signed_integer_le, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::signed-integer-little-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :signed_integer_be, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::signed-integer-big-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :unsigned_integer, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::unsigned-integer-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :unsigned_integer_le, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::unsigned-integer-little-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :unsigned_integer_be, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::unsigned-integer-big-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :float_le, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::float-little-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :float_be, n}, _from, state),
    do: read_and_reply(state, n, fn <<num::float-big-(n * 8)>> -> num end)

  @impl true
  def handle_call({:read, :bit_array, n}, _from, state) do
    with {:ok, {bit_array, state}} <- stream_bit_array(state, n) do
      {:reply, {:ok, bit_array}, state}
    else
      {:error, err} -> {:reply, {:error, err}, state}
    end
  end

  @impl true
  def handle_call({:read, {:bit_int, :little}, n}, _from, state) do
    num_bytes_needed = ceil(n / 8)

    with {:ok, {data, state}} <- stream_bitstring(state, num_bytes_needed, read_bits: n) do
      <<num::integer-little-size(n)>> = data
      {:reply, {:ok, num}, state}
    else
      {:error, err} -> {:reply, {:error, err}, state}
    end
  end

  @impl true
  def handle_call({:read, {:bit_int, :big}, n}, _from, state) do
    num_bytes_needed = ceil(n / 8)

    with {:ok, {data, state}} <- stream_bitstring(state, num_bytes_needed, read_bits: n) do
      <<num::integer-big-size(n)>> = data
      {:reply, {:ok, num}, state}
    else
      {:error, err} -> {:reply, {:error, err}, state}
    end
  end

  @impl true
  def handle_call({:read, :byte_array, n}, _from, state),
    do: read_and_reply(state, n, & &1)

  @impl true
  def handle_call({:read, :byte_array_full}, _from, state) do
    stream_state(
      size_bits: size_bits,
      pos_bits: pos_bits,
      buffer: buffer
    ) = state

    bits_left_in_stream = size_bits - pos_bits
    bits_in_buffer = bit_size(buffer)
    total_bytes_left = floor((bits_left_in_stream + bits_in_buffer) / 8)
    read_and_reply(state, total_bytes_left, & &1)
  end

  @impl true
  def handle_call(
        {:read, {:bytes_term, term_bin, include_term, consume_term, eos_error}},
        _from,
        state
      ) do
    Stream.iterate({:ok, {<<>>, state}}, fn {:ok, {_, curr_state}} ->
      stream_bitstring(curr_state, 1)
    end)
    |> Enum.reduce_while({state, <<>>}, fn
      {:ok, {next_byte, state}}, {_, buffer_bin} ->
        new_buffer_bin = buffer_bin <> <<next_byte::binary>>

        case new_buffer_bin do
          <<without_term::binary-size(byte_size(new_buffer_bin) - byte_size(term_bin)),
            ^term_bin::binary>> ->
            # The current buffer ends with the term we're searching for... Let's return...

            resp_data = if include_term, do: new_buffer_bin, else: without_term

            state =
              if consume_term do
                state
              else
                # If they don't want the term consumed, let's add it to the buffer to be re-consumed..
                stream_state(buffer: curr_buffer) = state
                stream_state(state, buffer: curr_buffer <> term_bin)
              end

            {:halt, {:reply, {:ok, resp_data}, state}}

          buffer_without_match ->
            {:cont, {state, buffer_without_match}}
        end

      {:error, :reached_eof}, {state, buffer_bin} ->
        if eos_error do
          {:halt, {:reply, {:error, :reached_eof}, state}}
        else
          {:halt, {:reply, {:ok, buffer_bin}, state}}
        end
    end)
  end

  @impl true
  def handle_call({:ensure, {:fixed_contents, contents}}, _from, state) do
    num_bytes = byte_size(contents)

    with {:ok, {data, state}} <- stream_bitstring(state, num_bytes) do
      if data == contents do
        {:reply, :ok, state}
      else
        {:reply, {:error, {:fixed_contents_mismatch, stream_state(state, :pos_bits) / 8, "Expected (#{inspect(contents)}) but found (#{inspect(data)})"}}, state}
      end
    else
      {:error, :reached_eof} ->
        {:reply, {:error, :reached_eof}, state}
    end
  end

  @impl true
  def handle_call({:seek, abs_pos_bytes}, _from, state) do
    stream_state(stream: stream, pos_bits: pos_bits, size_bits: size_bits) = state
    abs_pos_bits = abs_pos_bytes * 8

    cond do
      abs_pos_bits > size_bits ->
        {:reply, {:error, :reached_eof}, state}

      abs_pos_bits < pos_bits ->
        {:reply, {:error, :cannot_seek_backwards}, state}

      true ->
        pos_offset = ceil((abs_pos_bits - pos_bits) / 8)

        {:reply, :ok,
         stream_state(state, stream: Stream.drop(stream, pos_offset), pos_bits: abs_pos_bits)}
    end
  end

  @impl true
  def handle_cast(:align_to_byte, state) do
    {:noreply, stream_state(state, buffer: <<>>)}
  end

  @spec read_and_reply(stream_state(), num_bytes :: non_neg_integer(), reply_fn :: fun()) ::
          {:reply, term(), stream_state()}
  defp read_and_reply(state, n, reply_fn) do
    with {:ok, {data, state}} <- stream_bitstring(state, n) do
      {:reply, {:ok, reply_fn.(data)}, state}
    else
      error -> {:reply, error, state}
    end
  end

  @spec stream_bit_array(stream_state(), bits :: non_neg_integer()) ::
          {:ok, {data :: [boolean()], new_state :: stream_state()}} | {:error, read_error()}
  defp stream_bit_array(state, n_bits) do
    num_bytes_needed = ceil(n_bits / 8)

    with {:ok, {data, state}} <- stream_bitstring(state, num_bytes_needed, read_bits: n_bits) do
      data =
        for n <- 0..(n_bits - 1) do
          <<_::size(n), curr::unsigned-integer-size(1), _::size(bit_size(data) - n - 1)>> = data
          curr > 0
        end

      {:ok, {data, state}}
    end
  end

  @spec stream_bitstring(stream_state(), bytes :: non_neg_integer(), opts :: keyword()) ::
          {:ok, {data :: bitstring(), new_state :: stream_state()}} | {:error, read_error()}
  defp stream_bitstring(state, n_bytes, opts \\ []) do
    stream_state(
      stream: stream,
      pos_bits: pos_bits,
      size_bits: size_bits,
      buffer: buffer
    ) = state

    buffer_size_bits = bit_size(buffer)
    bits_needed = Keyword.get(opts, :read_bits, n_bytes * 8)
    bits_from_buffer = min(bits_needed, buffer_size_bits)
    bits_from_stream = bits_needed - bits_from_buffer

    cond do
      pos_bits + bits_from_stream > size_bits ->
        {:error, :reached_eof}

      true ->
        bytes_from_stream = ceil(bits_from_stream / 8)
        remaining_stream_bits = bytes_from_stream * 8 - bits_from_stream
        remaining_buffer_bits = buffer_size_bits - bits_from_buffer

        raw_stream_bin =
          Stream.take(stream, bytes_from_stream) |> Enum.to_list() |> :binary.list_to_bin()

        <<buffer_bin::size(bits_from_buffer), remaining_buffer::size(remaining_buffer_bits)>> =
          buffer

        <<stream_bin::size(bits_from_stream), remaining_stream::size(remaining_stream_bits)>> =
          raw_stream_bin

        all_data =
          if bits_from_buffer > 0,
            do: <<buffer_bin::size(bits_from_buffer), stream_bin::size(bits_from_stream)>>,
            else: <<stream_bin::size(bits_from_stream)>>

        new_buffer =
          if remaining_stream_bits > 0 do
            # If we touched the stream at all, we've exhausted the buffer
            # If we finished on the stream *not* aligned to bytes, let's make that last byte the buffer
            <<remaining_stream::size(remaining_stream_bits)>>
          else
            <<remaining_buffer::size(remaining_buffer_bits)>>
          end

        {:ok,
         {all_data,
          stream_state(state,
            pos_bits: pos_bits + bytes_from_stream * 8,
            buffer: new_buffer
          )}}
    end
  end
end
