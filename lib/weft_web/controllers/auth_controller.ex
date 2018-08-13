defmodule WeftWeb.AuthController do
  @moduledoc """
  Authenticates users.

  Currently a completely mock implementation that provides no security
  whatsoever.
  """

  use WeftWeb, :controller

  alias Weft.Auth

  @doc """
  The world's most trusting authentication endpoint.
  """
  def login(conn, %{"username" => username}) do
    user = Auth.get_user_by_name!(username)

    conn
    |> put_session(:current_user_id, user.id)
    |> send_resp(:ok, "")
  end
end
