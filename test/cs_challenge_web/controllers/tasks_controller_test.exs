defmodule CsChallengeWeb.TasksControllerTest do
  use CsChallengeWeb.ConnCase

  @valid_tasks_payload [
    %{"name" => "task-1", "command" => "touch /tmp/file1"},
    %{"name" => "task-2", "command" => "cat /tmp/file1", "requires" => ["task-3"]},
    %{"name" => "task-3", "command" => "echo 'Hello World!' > /tmp/file1", "requires" => ["task-1"]},
    %{"name" => "task-4", "command" => "rm /tmp/file1", "requires" => ["task-2", "task-3"]}
  ]

  @cycled_tasks_payload [
    %{"name" => "task-1", "command" => "touch /tmp/file1", "requires" => ["task-3"]},
    %{"name" => "task-2", "command" => "cat /tmp/file1", "requires" => ["task-3"]},
    %{"name" => "task-3", "command" => "echo 'Hello World!' > /tmp/file1", "requires" => ["task-1"]},
    %{"name" => "task-4", "command" => "rm /tmp/file1", "requires" => ["task-2", "task-3"]}
  ]

  test "POST /tasks", %{conn: conn} do
    conn = post(conn, ~p"/tasks", tasks: @valid_tasks_payload)

    assert json_response(conn, 200)
  end

  test "POST /tasks with cycled graph error", %{conn: conn} do
    conn = post(conn, ~p"/tasks", tasks: @cycled_tasks_payload)

    assert %{"errors" => %{"detail" => "The provided graph has at least one cycle"}} == json_response(conn, 403)
  end

  test "POST /tasks with empty graph error", %{conn: conn} do
    conn = post(conn, ~p"/tasks", tasks: [])

    assert %{"errors" => %{"detail" => "The provided graph is empty"}} == json_response(conn, 403)
  end
end
