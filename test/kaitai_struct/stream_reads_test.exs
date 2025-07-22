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
    stream = binary_stream(<<423::signed-integer-big-16>>)
    assert {:ok, 423} = KaitaiStruct.Stream.read_s2be(stream)

    stream = binary_stream(<<1042::signed-integer-big-16, -6232::signed-integer-big-16>>)
    assert {:ok, 1042} = KaitaiStruct.Stream.read_s2be(stream)
    assert {:ok, -6232} = KaitaiStruct.Stream.read_s2be(stream)
  end

  test "read_s2be/1 responds with error on EOF" do
    stream = binary_stream(<<423::signed-integer-big-8>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2be(stream)

    stream = binary_stream(<<592::signed-integer-big-16, -6232::signed-integer-big-8>>)
    assert {:ok, 592} = KaitaiStruct.Stream.read_s2be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2be(stream)
  end

  test "read_s2be!/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::signed-integer-big-16>>)
    assert 423 = KaitaiStruct.Stream.read_s2be!(stream)

    stream = binary_stream(<<1042::signed-integer-big-16, -6232::signed-integer-big-16>>)
    assert 1042 = KaitaiStruct.Stream.read_s2be!(stream)
    assert -6232 = KaitaiStruct.Stream.read_s2be!(stream)
  end

  test "read_s2be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::signed-integer-big-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s2be!(stream)
    end
  end

  test "read_s4be/1 reads 4 bytes properly" do
    stream = binary_stream(<<16_777_216::signed-integer-big-32>>)
    assert {:ok, 16_777_216} = KaitaiStruct.Stream.read_s4be(stream)

    stream =
      binary_stream(<<11_717_216::signed-integer-big-32, -12_774_216::signed-integer-big-32>>)

    assert {:ok, 11_717_216} = KaitaiStruct.Stream.read_s4be(stream)
    assert {:ok, -12_774_216} = KaitaiStruct.Stream.read_s4be(stream)
  end

  test "read_s4be/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-big-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4be(stream)

    stream = binary_stream(<<4324::signed-integer-big-32, -42123::signed-integer-big-8>>)
    assert {:ok, 4324} = KaitaiStruct.Stream.read_s4be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4be(stream)
  end

  test "read_s4be!/1 reads 4 bytes properly" do
    stream = binary_stream(<<82_994_923::signed-integer-big-32>>)
    assert 82_994_923 = KaitaiStruct.Stream.read_s4be!(stream)

    stream = binary_stream(<<1042::signed-integer-big-32, -64_432_232::signed-integer-big-32>>)
    assert 1042 = KaitaiStruct.Stream.read_s4be!(stream)
    assert -64_432_232 = KaitaiStruct.Stream.read_s4be!(stream)
  end

  test "read_s4be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::signed-integer-big-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s4be!(stream)
    end
  end

  test "read_s8be/1 reads 8 bytes properly" do
    stream = binary_stream(<<281_474_976_710_656::signed-integer-big-64>>)
    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_s8be(stream)

    stream =
      binary_stream(<<-281_474_976_710_656::signed-integer-big-64, 42::signed-integer-big-64>>)

    assert {:ok, -281_474_976_710_656} = KaitaiStruct.Stream.read_s8be(stream)
    assert {:ok, 42} = KaitaiStruct.Stream.read_s8be(stream)
  end

  test "read_s8be/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-big-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8be(stream)

    stream = binary_stream(<<543::signed-integer-big-64, -42123::signed-integer-big-32>>)
    assert {:ok, 543} = KaitaiStruct.Stream.read_s8be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8be(stream)
  end

  test "read_s8be!/1 reads 8 bytes properly" do
    stream = binary_stream(<<-391_474_976_710_456::signed-integer-big-64>>)
    assert -391_474_976_710_456 = KaitaiStruct.Stream.read_s8be!(stream)

    stream = binary_stream(<<2041::signed-integer-big-64, -64_431_232::signed-integer-big-64>>)
    assert 2041 = KaitaiStruct.Stream.read_s8be!(stream)
    assert -64_431_232 = KaitaiStruct.Stream.read_s8be!(stream)
  end

  test "read_s8be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::signed-integer-big-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s8be!(stream)
    end
  end

  test "read_s2le/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::signed-integer-little-16>>)
    assert {:ok, 423} = KaitaiStruct.Stream.read_s2le(stream)

    stream = binary_stream(<<1042::signed-integer-little-16, -6232::signed-integer-little-16>>)
    assert {:ok, 1042} = KaitaiStruct.Stream.read_s2le(stream)
    assert {:ok, -6232} = KaitaiStruct.Stream.read_s2le(stream)
  end

  test "read_s2le/1 responds with error on EOF" do
    stream = binary_stream(<<423::signed-integer-little-8>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2le(stream)

    stream = binary_stream(<<592::signed-integer-little-16, -6232::signed-integer-little-8>>)
    assert {:ok, 592} = KaitaiStruct.Stream.read_s2le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s2le(stream)
  end

  test "read_s2le!/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::signed-integer-little-16>>)
    assert 423 = KaitaiStruct.Stream.read_s2le!(stream)

    stream = binary_stream(<<1042::signed-integer-little-16, -6232::signed-integer-little-16>>)
    assert 1042 = KaitaiStruct.Stream.read_s2le!(stream)
    assert -6232 = KaitaiStruct.Stream.read_s2le!(stream)
  end

  test "read_s2le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::signed-integer-little-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s2le!(stream)
    end
  end

  test "read_s4le/1 reads 4 bytes properly" do
    stream = binary_stream(<<16_777_216::signed-integer-little-32>>)
    assert {:ok, 16_777_216} = KaitaiStruct.Stream.read_s4le(stream)

    stream =
      binary_stream(
        <<11_717_216::signed-integer-little-32, -12_774_216::signed-integer-little-32>>
      )

    assert {:ok, 11_717_216} = KaitaiStruct.Stream.read_s4le(stream)
    assert {:ok, -12_774_216} = KaitaiStruct.Stream.read_s4le(stream)
  end

  test "read_s4le/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-little-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4le(stream)

    stream = binary_stream(<<4324::signed-integer-little-32, -42123::signed-integer-little-8>>)
    assert {:ok, 4324} = KaitaiStruct.Stream.read_s4le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s4le(stream)
  end

  test "read_s4le!/1 reads 4 bytes properly" do
    stream = binary_stream(<<82_994_923::signed-integer-little-32>>)
    assert 82_994_923 = KaitaiStruct.Stream.read_s4le!(stream)

    stream =
      binary_stream(<<1042::signed-integer-little-32, -64_432_232::signed-integer-little-32>>)

    assert 1042 = KaitaiStruct.Stream.read_s4le!(stream)
    assert -64_432_232 = KaitaiStruct.Stream.read_s4le!(stream)
  end

  test "read_s4le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::signed-integer-little-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s4le!(stream)
    end
  end

  test "read_s8le/1 reads 8 bytes properly" do
    stream = binary_stream(<<281_474_976_710_656::signed-integer-little-64>>)
    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_s8le(stream)

    stream =
      binary_stream(
        <<-281_474_976_710_656::signed-integer-little-64, 42::signed-integer-little-64>>
      )

    assert {:ok, -281_474_976_710_656} = KaitaiStruct.Stream.read_s8le(stream)
    assert {:ok, 42} = KaitaiStruct.Stream.read_s8le(stream)
  end

  test "read_s8le/1 responds with error on EOF" do
    stream = binary_stream(<<823::signed-integer-little-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8le(stream)

    stream = binary_stream(<<543::signed-integer-little-64, -42123::signed-integer-little-32>>)
    assert {:ok, 543} = KaitaiStruct.Stream.read_s8le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_s8le(stream)
  end

  test "read_s8le!/1 reads 8 bytes properly" do
    stream = binary_stream(<<-391_474_976_710_456::signed-integer-little-64>>)
    assert -391_474_976_710_456 = KaitaiStruct.Stream.read_s8le!(stream)

    stream =
      binary_stream(<<2041::signed-integer-little-64, -64_431_232::signed-integer-little-64>>)

    assert 2041 = KaitaiStruct.Stream.read_s8le!(stream)
    assert -64_431_232 = KaitaiStruct.Stream.read_s8le!(stream)
  end

  test "read_s8le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::signed-integer-little-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s8le!(stream)
    end
  end

  test "read_u1/1 reads a byte properly" do
    stream = binary_stream(<<255::unsigned-integer-8>>)
    assert {:ok, 255} = KaitaiStruct.Stream.read_u1(stream)

    stream =
      binary_stream(<<4::unsigned-integer-8, 5::unsigned-integer-8, 6::unsigned-integer-8>>)

    assert {:ok, 4} = KaitaiStruct.Stream.read_u1(stream)
    assert {:ok, 5} = KaitaiStruct.Stream.read_u1(stream)
    assert {:ok, 6} = KaitaiStruct.Stream.read_u1(stream)
  end

  test "read_u1/1 responds with error on EOF" do
    stream = binary_stream(<<4::unsigned-integer-8>>)
    assert {:ok, 4} = KaitaiStruct.Stream.read_u1(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u1(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u1(stream)
  end

  test "read_u1!/1 reads a byte properly" do
    stream = binary_stream(<<255::unsigned-integer-8>>)
    assert 255 = KaitaiStruct.Stream.read_u1!(stream)

    stream =
      binary_stream(<<4::unsigned-integer-8, 5::unsigned-integer-8, 6::unsigned-integer-8>>)

    assert 4 = KaitaiStruct.Stream.read_u1!(stream)
    assert 5 = KaitaiStruct.Stream.read_u1!(stream)
    assert 6 = KaitaiStruct.Stream.read_u1!(stream)
  end

  test "read_u1!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4::unsigned-integer-8>>)
    assert 4 = KaitaiStruct.Stream.read_u1!(stream)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u1!(stream)
    end
  end

  test "read_u2be/1 reads 2 bytes properly" do
    stream = binary_stream(<<65_535::unsigned-integer-big-16>>)
    assert {:ok, 65_535} = KaitaiStruct.Stream.read_u2be(stream)

    stream = binary_stream(<<1042::unsigned-integer-big-16, 6232::unsigned-integer-big-16>>)
    assert {:ok, 1042} = KaitaiStruct.Stream.read_u2be(stream)
    assert {:ok, 6232} = KaitaiStruct.Stream.read_u2be(stream)
  end

  test "read_u2be/1 responds with error on EOF" do
    stream = binary_stream(<<255::unsigned-integer-big-8>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u2be(stream)

    stream = binary_stream(<<592::unsigned-integer-big-16, 6232::unsigned-integer-big-8>>)
    assert {:ok, 592} = KaitaiStruct.Stream.read_u2be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u2be(stream)
  end

  test "read_u2be!/1 reads 2 bytes properly" do
    stream = binary_stream(<<65_534::unsigned-integer-big-16>>)
    assert 65_534 = KaitaiStruct.Stream.read_u2be!(stream)

    stream = binary_stream(<<1042::unsigned-integer-big-16, 6232::unsigned-integer-big-16>>)
    assert 1042 = KaitaiStruct.Stream.read_u2be!(stream)
    assert 6232 = KaitaiStruct.Stream.read_u2be!(stream)
  end

  test "read_u2be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::unsigned-integer-big-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u2be!(stream)
    end
  end

  test "read_u4be/1 reads 4 bytes properly" do
    stream = binary_stream(<<4_294_967_295::unsigned-integer-big-32>>)
    assert {:ok, 4_294_967_295} = KaitaiStruct.Stream.read_u4be(stream)

    stream =
      binary_stream(<<11_717_216::unsigned-integer-big-32, 12_774_216::unsigned-integer-big-32>>)

    assert {:ok, 11_717_216} = KaitaiStruct.Stream.read_u4be(stream)
    assert {:ok, 12_774_216} = KaitaiStruct.Stream.read_u4be(stream)
  end

  test "read_u4be/1 responds with error on EOF" do
    stream = binary_stream(<<823::unsigned-integer-big-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u4be(stream)

    stream = binary_stream(<<4324::unsigned-integer-big-32, 42123::unsigned-integer-big-8>>)
    assert {:ok, 4324} = KaitaiStruct.Stream.read_u4be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u4be(stream)
  end

  test "read_u4be!/1 reads 4 bytes properly" do
    stream = binary_stream(<<82_994_923::unsigned-integer-big-32>>)
    assert 82_994_923 = KaitaiStruct.Stream.read_u4be!(stream)

    stream = binary_stream(<<1042::unsigned-integer-big-32, 64_432_232::unsigned-integer-big-32>>)
    assert 1042 = KaitaiStruct.Stream.read_u4be!(stream)
    assert 64_432_232 = KaitaiStruct.Stream.read_u4be!(stream)
  end

  test "read_u4be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::unsigned-integer-big-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_s4be!(stream)
    end
  end

  test "read_u8be/1 reads 8 bytes properly" do
    stream = binary_stream(<<18_446_744_073_709_551_615::unsigned-integer-big-64>>)
    assert {:ok, 18_446_744_073_709_551_615} = KaitaiStruct.Stream.read_u8be(stream)

    stream =
      binary_stream(<<281_474_976_710_656::unsigned-integer-big-64, 42::unsigned-integer-big-64>>)

    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_u8be(stream)
    assert {:ok, 42} = KaitaiStruct.Stream.read_u8be(stream)
  end

  test "read_u8be/1 responds with error on EOF" do
    stream = binary_stream(<<823::unsigned-integer-big-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u8be(stream)

    stream = binary_stream(<<543::unsigned-integer-big-64, -42123::unsigned-integer-big-32>>)
    assert {:ok, 543} = KaitaiStruct.Stream.read_u8be(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u8be(stream)
  end

  test "read_u8be!/1 reads 8 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::unsigned-integer-big-64>>)
    assert 391_474_976_710_456 = KaitaiStruct.Stream.read_u8be!(stream)

    stream = binary_stream(<<2041::unsigned-integer-big-64, 64_431_232::unsigned-integer-big-64>>)
    assert 2041 = KaitaiStruct.Stream.read_u8be!(stream)
    assert 64_431_232 = KaitaiStruct.Stream.read_u8be!(stream)
  end

  test "read_u8be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::unsigned-integer-big-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u8be!(stream)
    end
  end

  test "read_u2le/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::unsigned-integer-little-16>>)
    assert {:ok, 423} = KaitaiStruct.Stream.read_u2le(stream)

    stream = binary_stream(<<1042::unsigned-integer-little-16, 6232::unsigned-integer-little-16>>)
    assert {:ok, 1042} = KaitaiStruct.Stream.read_u2le(stream)
    assert {:ok, 6232} = KaitaiStruct.Stream.read_u2le(stream)
  end

  test "read_u2le/1 responds with error on EOF" do
    stream = binary_stream(<<423::unsigned-integer-little-8>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u2le(stream)

    stream = binary_stream(<<592::unsigned-integer-little-16, 6232::unsigned-integer-little-8>>)
    assert {:ok, 592} = KaitaiStruct.Stream.read_u2le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u2le(stream)
  end

  test "read_u2le!/1 reads 2 bytes properly" do
    stream = binary_stream(<<423::unsigned-integer-little-16>>)
    assert 423 = KaitaiStruct.Stream.read_u2le!(stream)

    stream = binary_stream(<<1042::unsigned-integer-little-16, 6232::unsigned-integer-little-16>>)
    assert 1042 = KaitaiStruct.Stream.read_u2le!(stream)
    assert 6232 = KaitaiStruct.Stream.read_u2le!(stream)
  end

  test "read_u2le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<423::unsigned-integer-little-8>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u2le!(stream)
    end
  end

  test "read_u4le/1 reads 4 bytes properly" do
    stream = binary_stream(<<16_777_216::unsigned-integer-little-32>>)
    assert {:ok, 16_777_216} = KaitaiStruct.Stream.read_u4le(stream)

    stream =
      binary_stream(
        <<11_717_216::unsigned-integer-little-32, 12_774_216::unsigned-integer-little-32>>
      )

    assert {:ok, 11_717_216} = KaitaiStruct.Stream.read_u4le(stream)
    assert {:ok, 12_774_216} = KaitaiStruct.Stream.read_u4le(stream)
  end

  test "read_u4le/1 responds with error on EOF" do
    stream = binary_stream(<<823::unsigned-integer-little-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u4le(stream)

    stream = binary_stream(<<4324::unsigned-integer-little-32, 42123::unsigned-integer-little-8>>)
    assert {:ok, 4324} = KaitaiStruct.Stream.read_u4le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u4le(stream)
  end

  test "read_u4le!/1 reads 4 bytes properly" do
    stream = binary_stream(<<82_994_923::unsigned-integer-little-32>>)
    assert 82_994_923 = KaitaiStruct.Stream.read_u4le!(stream)

    stream =
      binary_stream(<<1042::unsigned-integer-little-32, 64_432_232::unsigned-integer-little-32>>)

    assert 1042 = KaitaiStruct.Stream.read_u4le!(stream)
    assert 64_432_232 = KaitaiStruct.Stream.read_u4le!(stream)
  end

  test "read_u4le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::unsigned-integer-little-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u4le!(stream)
    end
  end

  test "read_u8le/1 reads 8 bytes properly" do
    stream = binary_stream(<<281_474_976_710_656::unsigned-integer-little-64>>)
    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_u8le(stream)

    stream =
      binary_stream(
        <<281_474_976_710_656::unsigned-integer-little-64, 42::unsigned-integer-little-64>>
      )

    assert {:ok, 281_474_976_710_656} = KaitaiStruct.Stream.read_u8le(stream)
    assert {:ok, 42} = KaitaiStruct.Stream.read_u8le(stream)
  end

  test "read_u8le/1 responds with error on EOF" do
    stream = binary_stream(<<823::unsigned-integer-little-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u8le(stream)

    stream = binary_stream(<<543::unsigned-integer-little-64, 42123::unsigned-integer-little-32>>)
    assert {:ok, 543} = KaitaiStruct.Stream.read_u8le(stream)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_u8le(stream)
  end

  test "read_u8le!/1 reads 8 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::unsigned-integer-little-64>>)
    assert 391_474_976_710_456 = KaitaiStruct.Stream.read_u8le!(stream)

    stream =
      binary_stream(<<2041::unsigned-integer-little-64, 64_431_232::unsigned-integer-little-64>>)

    assert 2041 = KaitaiStruct.Stream.read_u8le!(stream)
    assert 64_431_232 = KaitaiStruct.Stream.read_u8le!(stream)
  end

  test "read_u8le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::unsigned-integer-little-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_u8le!(stream)
    end
  end

  test "read_f4be/1 reads 4 bytes properly" do
    stream = binary_stream(<<-123.0e-5::float-big-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4be(stream)
    assert_in_delta x, -123.0e-5, 0.01

    stream = binary_stream(<<442.0e10::float-big-32, 42.0::float-big-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4be(stream)
    assert_in_delta x, 442.0e10, 500_000

    assert {:ok, 42.0} = KaitaiStruct.Stream.read_f4be(stream)
  end

  test "read_f4be/1 responds with error on EOF" do
    stream = binary_stream(<<823::float-big-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f4be(stream)

    stream = binary_stream(<<543::float-big-32, 42123::float-big-16>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4be(stream)
    assert_in_delta x, 543.0, 0.1

    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f4be(stream)
  end

  test "read_f4be!/1 reads 4 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::float-big-32>>)
    assert_in_delta 391_474_976_710_456, KaitaiStruct.Stream.read_f4be!(stream), 100_000_000

    stream = binary_stream(<<2041::float-big-32, 64_431_232::float-big-32>>)
    assert_in_delta 2041.0, KaitaiStruct.Stream.read_f4be!(stream), 0.1
    assert_in_delta 64_431_232, KaitaiStruct.Stream.read_f4be!(stream), 0.1
  end

  test "read_f4be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::float-big-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_f4be!(stream)
    end
  end

  test "read_f8be/1 reads 8 bytes properly" do
    stream = binary_stream(<<-123.0e-5::float-big-64>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8be(stream)
    assert_in_delta x, -123.0e-5, 0.01

    stream = binary_stream(<<442.0e10::float-big-64, 42.0::float-big-64>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8be(stream)
    assert_in_delta x, 442.0e10, 500_000

    assert {:ok, 42.0} = KaitaiStruct.Stream.read_f8be(stream)
  end

  test "read_f8be/1 responds with error on EOF" do
    stream = binary_stream(<<823::float-big-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f8be(stream)

    stream = binary_stream(<<543::float-big-64, 42123::float-big-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8be(stream)
    assert_in_delta x, 543.0, 0.1

    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f8be(stream)
  end

  test "read_f8be!/1 reads 8 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::float-big-64>>)
    assert_in_delta 391_474_976_710_456, KaitaiStruct.Stream.read_f8be!(stream), 100_000_000

    stream = binary_stream(<<2041::float-big-64, 64_431_232::float-big-64>>)
    assert_in_delta 2041.0, KaitaiStruct.Stream.read_f8be!(stream), 0.1
    assert_in_delta 64_431_232, KaitaiStruct.Stream.read_f8be!(stream), 0.1
  end

  test "read_f8be!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::float-big-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_f8be!(stream)
    end
  end

  test "read_f4le/1 reads 4 bytes properly" do
    stream = binary_stream(<<-123.0e-5::float-little-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4le(stream)
    assert_in_delta x, -123.0e-5, 0.01

    stream = binary_stream(<<442.0e10::float-little-32, 42.0::float-little-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4le(stream)
    assert_in_delta x, 442.0e10, 500_000

    assert {:ok, 42.0} = KaitaiStruct.Stream.read_f4le(stream)
  end

  test "read_f4le/1 responds with error on EOF" do
    stream = binary_stream(<<823::float-little-16>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f4le(stream)

    stream = binary_stream(<<543::float-little-32, 42123::float-little-16>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f4le(stream)
    assert_in_delta x, 543.0, 0.1

    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f4le(stream)
  end

  test "read_f4le!/1 reads 4 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::float-little-32>>)
    assert_in_delta 391_474_976_710_456, KaitaiStruct.Stream.read_f4le!(stream), 100_000_000

    stream = binary_stream(<<2041::float-little-32, 64_431_232::float-little-32>>)
    assert_in_delta 2041.0, KaitaiStruct.Stream.read_f4le!(stream), 0.1
    assert_in_delta 64_431_232, KaitaiStruct.Stream.read_f4le!(stream), 0.1
  end

  test "read_f4le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::float-little-16>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_f4le!(stream)
    end
  end

  test "read_f8le/1 reads 8 bytes properly" do
    stream = binary_stream(<<-123.0e-5::float-little-64>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8le(stream)
    assert_in_delta x, -123.0e-5, 0.01

    stream = binary_stream(<<442.0e10::float-little-64, 42.0::float-little-64>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8le(stream)
    assert_in_delta x, 442.0e10, 500_000

    assert {:ok, 42.0} = KaitaiStruct.Stream.read_f8le(stream)
  end

  test "read_f8le/1 responds with error on EOF" do
    stream = binary_stream(<<823::float-little-32>>)
    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f8le(stream)

    stream = binary_stream(<<543::float-little-64, 42123::float-little-32>>)
    assert {:ok, x} = KaitaiStruct.Stream.read_f8le(stream)
    assert_in_delta x, 543.0, 0.1

    assert {:error, :reached_eof} = KaitaiStruct.Stream.read_f8le(stream)
  end

  test "read_f8le!/1 reads 8 bytes properly" do
    stream = binary_stream(<<391_474_976_710_456::float-little-64>>)
    assert_in_delta 391_474_976_710_456, KaitaiStruct.Stream.read_f8le!(stream), 100_000_000

    stream = binary_stream(<<2041::float-little-64, 64_431_232::float-little-64>>)
    assert_in_delta 2041.0, KaitaiStruct.Stream.read_f8le!(stream), 0.1
    assert_in_delta 64_431_232, KaitaiStruct.Stream.read_f8le!(stream), 0.1
  end

  test "read_f8le!/1 raises ReadError on EOF" do
    stream = binary_stream(<<4_262_233::float-little-32>>)

    assert_raise KaitaiStruct.Stream.ReadError, fn ->
      KaitaiStruct.Stream.read_f8le!(stream)
    end
  end

  defp binary_stream(bin_data) do
    io_stream = StringIO.open(bin_data) |> then(fn {:ok, io} -> IO.binstream(io, 1) end)
    {:ok, kaitai} = GenServer.start_link(KaitaiStruct.Stream, {io_stream, byte_size(bin_data)})
    kaitai
  end
end
