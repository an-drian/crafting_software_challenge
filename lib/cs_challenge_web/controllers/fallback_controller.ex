defmodule CsChallengeWeb.FallbackController do
  use Phoenix.Controller

  def init(opts), do: opts

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: CsChallengeWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, %{message: message}}) do
    conn
    |> put_status(403)
    |> put_view(json: CsChallengeWeb.ErrorJSON)
    |> render(:"403", message: message)
  end
end
