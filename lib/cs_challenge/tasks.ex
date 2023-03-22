defmodule CsChallenge.Tasks do
  @type sorted_task_type() :: %{
          required(:name) => String.t(),
          required(:command) => String.t()
        }

  @spec run(tasks :: list()) ::
          {:ok, list(sorted_task_type())} | {:error, %{required(:message) => String.t()}}
  def run([]), do: {:error, %{message: "The provided graph is empty"}}

  def run(tasks) do
    tasks_graph = convert_to_graph(tasks)
    reversed_graph = reversed_tasks_graph(tasks_graph)
    nodes_without_dependencies = find_nodes_without_dependencies(tasks_graph)

    if Enum.empty?(nodes_without_dependencies) do
      {:error, %{message: "The provided graph has at least one cycle"}}
    else
      {:ok, bfs(tasks_graph, nodes_without_dependencies, reversed_graph, [])}
    end
  end

  defp bfs(_graph, [], _reversed_graph, result), do: Enum.reverse(result)

  defp bfs(
         graph,
         [node_without_dependencies_h | nodes_without_dependencies_t],
         reversed_graph,
         result
       ) do
    {node_name, info} = node_without_dependencies_h

    result = [info | result]

    graph =
      graph
      |> Map.delete(node_name)
      |> remove_dependency_from_graph(reversed_graph, node_name)

    nodes_without_dependencies =
      List.flatten([nodes_without_dependencies_t | find_nodes_without_dependencies(graph)])

    bfs(graph, nodes_without_dependencies, reversed_graph, result)
  end

  defp remove_dependency_from_graph(graph, reversed_graph, child_name) do
    filter_by_child_name = fn list, child_name -> Enum.filter(list, &(&1 != child_name)) end

    if is_nil(reversed_graph[child_name]) do
      graph
    else
      Enum.reduce(reversed_graph[child_name], graph, fn reversed_graph_key, current_graph_acc ->
        current_node = current_graph_acc[reversed_graph_key]

        %{
          current_graph_acc
          | reversed_graph_key => %{
              current_node
              | dependencies: filter_by_child_name.(current_node.dependencies, child_name)
            }
        }
      end)
    end
  end

  defp find_nodes_without_dependencies(graph),
    do: Enum.filter(graph, fn {_k, val} -> Enum.empty?(val.dependencies) end)

  defp convert_to_graph(tasks) do
    tasks
    |> Enum.into(%{}, fn item ->
      {item["name"],
       %{
         command: item["command"],
         dependencies: item["requires"] || [],
         name: item["name"]
       }}
    end)
  end

  defp reversed_tasks_graph(graph) do
    Enum.reduce(graph, %{}, fn {task_name, task}, reversed_graph_acc ->
      Map.merge(
        reversed_graph_acc,
        Enum.reduce(task.dependencies, %{}, fn dep_name, acc ->
          Map.put(acc, dep_name, [task_name | reversed_graph_acc[dep_name] || []])
        end)
      )
    end)
  end
end
