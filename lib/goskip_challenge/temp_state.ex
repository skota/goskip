defmodule GoskipChallenge.TempStateAgent do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end


  def find_items(type, degrees) do
      value()
      |> filter(type, degrees)
  end

  defp filter(items,type, degrees) when is_list(items) do
    IO.puts "value returned is a list type: #{type} abd degrees: #{degrees}"
    Enum.filter(items, fn x ->
      x["type"] == type and x["degrees"] == degrees
    end)
  end

  defp filter(items,type, degrees)  do
    IO.puts "value returned is a single item"
    if items["type"] == type and items["degrees"] == degrees do
      # we found a match
      items
    else
      %{}
    end

  end
  def add_item(degrees, type, result) do
    data = %{"type" => type, "degrees" => degrees, "conversions" => result}
    Agent.update(__MODULE__, fn (state) -> state ++ [data] end)
  end
end
