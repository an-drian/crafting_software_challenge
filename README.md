# CsChallenge

This is an implementation of topological sort algorithm

To test solution you go through next steps:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server` Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
  *To test the solution you should make a POST request to `localhost:4000/tasks`
    
Here is a terminal example
  ```
curl --location --request POST 'http://localhost:4000/tasks' \
--header 'Content-Type: application/json' \
--data-raw '{
    "tasks": [
        {
            "name": "task-1",
            "command": "touch /tmp/file1"
        },
        {
            "name": "task-2",
            "command":"cat /tmp/file1",
            "requires":[
                "task-3"
            ]
        },
        {
            "name": "task-3",
            "command": "echo '\''Hello World!'\'' > /tmp/file1",
            "requires": [
                "task-1"
            ]
        },
        {
            "name": "task-4",
            "command": "rm /tmp/file1",
            "requires":[
                "task-2",
                "task-3"
            ]
        }
    ]
}'
  ``` 
Also feel free to use Postman, Insomnia or any whatever you like
