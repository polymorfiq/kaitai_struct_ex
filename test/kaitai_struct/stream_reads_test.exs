defmodule KaitaiStruct.StreamReadsTest do
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

  test "read_s1!/1 reads a byte properly" do
    stream = binary_stream(<<45::signed-integer-8>>)
    assert 45 = KaitaiStruct.Stream.read_s1!(stream)

    stream = binary_stream(<<4::signed-integer-8, -5::signed-integer-8, 6::signed-integer-8>>)
    assert 4 = KaitaiStruct.Stream.read_s1!(stream)
    assert -5 = KaitaiStruct.Stream.read_s1!(stream)
    assert 6 = KaitaiStruct.Stream.read_s1!(stream)
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

  test "read_s2be!/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::signed-integer-16>>)
    assert 423 = KaitaiStruct.Stream.read_s2be!(stream)

    stream = binary_stream(<<1042::signed-integer-16, -6232::signed-integer-16>>)
    assert 1042 = KaitaiStruct.Stream.read_s2be!(stream)
    assert -6232 = KaitaiStruct.Stream.read_s2be!(stream)
  end

  test "read_s2be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::signed-integer-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s2be!(stream)
    end
  end

  test "read_s4be/1 reads 4 bytes properly" do
    stream = binary_stream(<<16_777_216::signed-integer-32>>)
    assert {:ok, 16_777_216} = KaitaiStruct.Stream.read_s4be(stream)

    stream = binary_stream(<<11_717_216::signed-integer-32, -12_774_216::signed-integer-32>>)
    assert {:ok, 11_717_216} = KaitaiStruct.Stream.read_s4be(stream)
    assert {:ok, -12_774_216} = KaitaiStruct.Stream.read_s4be(stream)
  end

  test "read_s4be/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4be(stream)

    stream = binary_stream(<<4324::signed-integer-32, -42123::signed-integer-8>>)
    assert {:ok, 4324} = KaitaiStruct.Stream.read_s4be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4be(stream)
  end

  test "read_s4be!/1 reads 4 bytes properly" do
    stream = binary_stream(<<82_994_923::signed-integer-32>>)
    assert 82_994_923 = KaitaiStruct.Stream.read_s4be!(stream)

    stream = binary_stream(<<1042::signed-integer-32, -64_432_232::signed-integer-32>>)
    assert 1042 = KaitaiStruct.Stream.read_s4be!(stream)
    assert -64_432_232 = KaitaiStruct.Stream.read_s4be!(stream)
  end

  test "read_s4be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4262233::signed-integer-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s4be!(stream)
    end
  end

  test "read_s8be/1 reads 8 bytes properly" do
    stream = binary_stream(<<281_474_976_710_656::signed-integer-64>>)
    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_s8be(stream)

    stream = binary_stream(<<-281_474_976_710_656::signed-integer-64, 42::signed-integer-64>>)
    assert {:ok, -281_474_976_710_656} = KaitaiStruct.Stream.read_s8be(stream)
    assert {:ok, 42} = KaitaiStruct.Stream.read_s8be(stream)
  end

  test "read_s8be/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8be(stream)

    stream = binary_stream(<<543::signed-integer-64, -42123::signed-integer-32>>)
    assert {:ok, 543} = KaitaiStruct.Stream.read_s8be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8be(stream)
  end

  test "read_s8be!/1 reads 8 bytes properly" do
    stream = binary_stream(<<-391_474_976_710_456::signed-integer-64>>)
    assert -391_474_976_710_456 = KaitaiStruct.Stream.read_s8be!(stream)

    stream = binary_stream(<<2041::signed-integer-64, -64_431_232::signed-integer-64>>)
    assert 2041 = KaitaiStruct.Stream.read_s8be!(stream)
    assert -64_431_232 = KaitaiStruct.Stream.read_s8be!(stream)
  end

  test "read_s8be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4262233::signed-integer-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s8be!(stream)
    end
  end

  defp binary_stream(bin_data) do
    io_stream = StringIO.open(bin_data) |> then(fn {:ok, io} -> IO.binstream(io, 1) end)
    {:ok, kaitai} = GenServer.start_link(KaitaiStruct.Stream, {io_stream, byte_size(bin_data)})
    kaitai
  end
end
