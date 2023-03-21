defmodule CsChallenge.Tasks do
  def run(tasks) do
    graph = convert_to_graph(tasks)
    nodes_without_children = find_nodes_without_children(graph)

    if Enum.empty?(nodes_without_children) do
      {:error, %{message: "The provided graph has at least one cycle"}}
    else
      {:ok, bfs(graph, nodes_without_children, [])}
    end
    |> IO.inspect(label: "nodes_without_children")


    {:ok, []}
  end

  def bfs(_graph, [], result), do: Enum.reverse(result)

  def bfs(graph, [node_without_children_h | nodes_without_children_t], result) do
    {node_name, info} = node_without_children_h

    result = [info | result]

    graph =
      graph
      |> Map.delete(node_name)
      |> remove_child_from_graph(node_name)
      |> IO.inspect(label: "RESULT")


    nodes_without_children = List.flatten([nodes_without_children_t | find_nodes_without_children(graph)])

    bfs(graph, nodes_without_children, result)
  end

  def remove_child_from_graph(graph, child_name) do
    filter_by_child_name = fn list, child_name -> Enum.filter(list, &(&1 != child_name)) end

    Enum.into(graph, %{}, fn {k, v} -> {k, %{v | children: filter_by_child_name.(v.children, child_name)}} end)
  end

  def find_nodes_without_children(graph),
    do: Enum.filter(graph, fn {_k, val} -> Enum.empty?(val.children) end)

  defp convert_to_graph(tasks) do
    tasks
    |> Enum.into(%{}, fn item ->
      {item["name"],
       %{
         command: item["command"],
         children: item["requires"] || [],
         name: item["name"]
       }}
    end)
  end

  # def convert_to_system_command(command) do
  #   [head | tail] = String.split(command)

  #   System.cmd(head, tail)
  # end
end
