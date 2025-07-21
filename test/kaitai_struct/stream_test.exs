defmodule KaitaiStruct.StreamTest do
  use ExUnit.Case
  doctest KaitaiStruct.Stream

  test "read_s1/1 reads a byte properly" do
    stream = binary_stream(<<45::signed-integer-8>>)
    assert {:ok, 45} = KaitaiStruct.Stream.read_s1(stream)

    stream = binary_stream(<<4::signed-integer-8, -5::signed-integer-8, 6::signed-integer-8>>)
    assert {:ok, 4} = KaitaiStruct.Stream.read_s1(stream)
    assert {:ok, -5} = KaitaiStruct.Stream.read_s1(stream)
    assert {:ok, 6} = KaitaiStruct.Stream.read_s1(stream)
  end

  test "read_s1/1 responds with error on EOF" do
    stream = binary_stream(<<4::signed-integer-8>>)
    assert {:ok, 4} = KaitaiStruct.Stream.read_s1(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s1(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s1(stream)
  end

  test "read_s1!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4::signed-integer-8>>)
    assert 4 = KaitaiStruct.Stream.read_s1!(stream)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s1!(stream)
    end
  end

  test "read_s2be/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::signed-integer-16>>)
    assert {:ok, 423} = KaitaiStruct.Stream.read_s2be(stream)

    stream = binary_stream(<<1042::signed-integer-16, -6232::signed-integer-16>>)
    assert {:ok, 1042} = KaitaiStruct.Stream.read_s2be(stream)
    assert {:ok, -6232} = KaitaiStruct.Stream.read_s2be(stream)
  end

  test "read_s2be/1 responds with error on EOF" do
    stream = binary_stream(<<423::signed-integer-8>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2be(stream)

    stream = binary_stream(<<592::signed-integer-16, -6232::signed-integer-8>>)
    assert {:ok, 592} = KaitaiStruct.Stream.read_s2be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2be(stream)
  end

  test "read_s2be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::signed-integer-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s2be!(stream)
    end
  end

  defp binary_stream(bin_data) do
    io_stream = StringIO.open(bin_data) |> then(fn {:ok, io} -> IO.binstream(io, 1) end)
    {:ok, kaitai} = GenServer.start_link(KaitaiStruct.Stream, {io_stream, byte_size(bin_data)})
    kaitai
  end
end
