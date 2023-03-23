defmodule CsChallengeWeb.PageControllerTest do
  use CsChallengeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Hello world!"
  end
end
