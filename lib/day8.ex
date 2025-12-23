defmodule Point do
  defstruct [:x, :y, :z]

  def eq(p1, p2) do
    p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
  end

  def display(p) do
    "(#{p.x},#{p.y},#{p.z})"
  end

  def order_invariant_string(p1, p2) do
    xx = if p1.x <= p2.x, do: "#{p1.x}#{p2.x}", else: "#{p2.x}#{p1.x}"
    yy = if p1.y <= p2.y, do: "#{p1.y}#{p2.y}", else: "#{p2.y}#{p1.y}"
    zz = if p1.z <= p2.z, do: "#{p1.z}#{p2.z}", else: "#{p2.z}#{p1.z}"
    xx <> yy <> zz
  end

end

defmodule JunctionBoxes do
  def largest_circuits_product(filename) do
    points = String.split(File.read!(filename))
    |> Enum.map(fn s ->
      [x, y, z] = String.split(s, ",") |> Enum.map(&String.to_integer/1)
      %Point{ x: x, y: y, z: z}
    end)

    pairs = get_ordered_pairs(points)

    part_one = create_circuits(pairs)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.product()
    { p1, p2 } = create_circuits_until_full(Enum.map(points, &([&1])), pairs)
    { part_one, p1.x * p2.x }
  end

  def create_circuits_until_full(circuits, [{p1, p2, _distance} | rest]) do
    new_circuits = update_circuits(circuits, p1, p2)
    case Enum.count(new_circuits) == 1 do
      :true -> { p1, p2 }
      :false -> create_circuits_until_full(new_circuits, rest)
    end
  end

  def create_circuits(ordered_pairs) do
    ordered_pairs
    |> Enum.take(1000)
    |> Enum.reduce([], fn { p1, p2, _distance }, circuits -> update_circuits(circuits, p1, p2) end)
  end

  def get_ordered_pairs(points) do
    points
    |> Enum.flat_map(fn p1 ->
      points
      |> Enum.map(fn p2 ->
        { p1, p2, :math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2 + (p1.z - p2.z)**2) }
      end)
      |> Enum.filter(fn { _p1, _p2, distance } -> distance > 0 end)
    end)
    |> Enum.sort(fn { _p11, _p12, distance1 }, { _p21, _p22, distance2} -> distance1 <= distance2 end)
    |> Enum.uniq_by(fn { p1, p2, distance } -> "#{Point.order_invariant_string(p1, p2)}#{distance}" end)
  end

  def update_circuits(circuits, p1, p2) do
    { my_circuit, replaced_indices } = circuits
    |> Enum.with_index(fn element, index -> {element, index} end)
    |> Enum.reduce({[p1, p2], []}, fn { circuit, index }, { my_circuit, replaced_indices} ->
      case Enum.any?(circuit, fn p -> Point.eq(p, p1) or Point.eq(p, p2) end) do
        :true -> { Enum.uniq(my_circuit ++ circuit), replaced_indices ++ [index] }
        :false -> { my_circuit, replaced_indices }
      end
    end)
    case replaced_indices do
      [] -> circuits ++ [my_circuit]
      _ -> drop_indexes(circuits, replaced_indices) ++ [my_circuit]
    end
  end

  def drop_indexes(list, []) do
    list
  end
  def drop_indexes(list, [i | indexes]) do
    drop_indexes(List.delete_at(list, i), Enum.map(indexes, &(&1 - 1)))
  end
end
