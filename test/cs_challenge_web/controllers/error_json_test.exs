defmodule CsChallengeWeb.ErrorJSONTest do
  use CsChallengeWeb.ConnCase, async: true

  test "renders 404" do
    assert CsChallengeWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CsChallengeWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders error with custom message" do
    assert CsChallengeWeb.ErrorJSON.render("403.json", %{message: "Some cool error message"}) ==
      %{errors: %{detail: "Some cool error message"}}
  end
end
