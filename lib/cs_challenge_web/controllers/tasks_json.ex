defmodule CsChallengeWeb.TasksJSON do
  def render(_template, %{tasks: tasks}) do
    tasks = Enum.map(tasks, &%{command: &1.command, name: &1.name})

    %{tasks: tasks, commands: ordered_list_of_commans(tasks)}
  end

  defp ordered_list_of_commans(tasks),
    do: "#!/usr/bin/env bash\n" <> Enum.map_join(tasks, "\n", & &1.command)
end
