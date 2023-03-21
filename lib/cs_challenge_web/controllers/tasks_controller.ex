defmodule CsChallengeWeb.TasksController do
  use CsChallengeWeb, :controller

  def execute(conn, %{"tasks" => tasks}) do
    with {:ok, sorted_tasks} <- CsChallenge.Tasks.run(tasks) do
      render(conn, :tasks, tasks: sorted_tasks)
    end
  end
end
