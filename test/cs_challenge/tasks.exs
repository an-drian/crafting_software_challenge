defmodule CsChallenge.TasksTests do
  use ExUnit.Case, async: true
  alias CsChallenge.Tasks

  describe "run/1" do
    test "successfully sorted" do
      tasks = [
        %{"name" => "task-1", "command" => "touch /tmp/file1"},
        %{"name" => "task-2", "command" => "cat /tmp/file1", "requires" => ["task-3"]},
        %{"name" => "task-3", "command" => "echo 'Hello World!' > /tmp/file1", "requires" => ["task-1"]},
        %{"name" => "task-4", "command" => "rm /tmp/file1", "requires" => ["task-2", "task-3"]}
      ]

      {:ok,
      [
        %{command: "touch /tmp/file1", dependencies: [], name: "task-1"},
        %{
          command: "echo 'Hello World!' > /tmp/file1",
          dependencies: [],
          name: "task-3"
        },
        %{command: "cat /tmp/file1", dependencies: [], name: "task-2"},
        %{command: "rm /tmp/file1", dependencies: [], name: "task-4"}
      ]}

      assert {:ok, [
        %{name: "task-1"},
        %{name: "task-3"},
        %{name: "task-2"},
        %{name: "task-4"}
      ]} = Tasks.run(tasks)
    end

    test "error caused by empty graph" do
      assert {:error, %{message: "The provided graph is empty"}} = Tasks.run([])
    end

    test "error caused by cycled graph" do
      tasks = [
        %{"name" => "task-1", "command" => "touch /tmp/file1", "requires" => ["task-4"]},
        %{"name" => "task-2", "command" => "cat /tmp/file1", "requires" => ["task-3"]},
        %{"name" => "task-3", "command" => "echo 'Hello World!' > /tmp/file1", "requires" => ["task-1"]},
        %{"name" => "task-4", "command" => "rm /tmp/file1", "requires" => ["task-2", "task-3"]}
      ]

      assert {:error, %{message: "The provided graph has at least one cycle"}} = Tasks.run(tasks)
    end
  end
end
