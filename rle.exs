defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """
  @spec encode(String.t) :: String.t
  def encode(string), do: encode(string |> String.codepoints, "", nil, 0)
  def encode([], result, current, counter) do
    if counter > 0, do: result <> Integer.to_string(counter) <> current, else: result
  end
  def encode([head | tail], result, current, counter) do
    cond do
      current == head ->
        encode(tail, result, head, counter + 1)
      current ->
        encode([head | tail], result <> Integer.to_string(counter) <> current, nil, 0)
      true ->
        encode(tail, result, head, 1)
    end
  end

  @spec decode(String.t) :: String.t
  def decode(string), do: decode(string |> String.codepoints, "", "")
  def decode([], result, counter), do: result
  def decode([head | tail], result, counter) do
    cond do
      head =~ ~r/[0-9]/ ->
        decode(tail, result, counter <> head)
      true ->
        decode(tail, result <> get_string(head, String.to_integer(counter)), "")
    end
  end

  defp get_string(current, counter), do: (for _i <- 1..counter, do: current) |> to_string
end
