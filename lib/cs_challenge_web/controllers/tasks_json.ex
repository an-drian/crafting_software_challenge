defmodule CsChallengeWeb.TasksJSON do
  def render(template, _assigns) do
    template |> IO.inspect(label: "template")
    %{tasks: []}
  end
end
