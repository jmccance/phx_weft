defmodule WeftWeb.PostController do
  use WeftWeb, :controller

  alias Weft.Timeline
  alias Weft.Timeline.Post

  action_fallback(WeftWeb.FallbackController)

  def index(conn, _params) do
    posts = Timeline.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def index_by_owner(conn, %{"owner_id" => owner_id}) do
    posts = Timeline.list_posts_by_owner(owner_id)
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    current_user_id = get_session(conn, :current_user_id)

    with {:ok, %Post{} = post} <-
           Timeline.create_post(
             post_params,
             current_user_id
           ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Timeline.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def delete(conn, %{"id" => id}) do
    post = Timeline.get_post!(id)

    with {:ok, %Post{}} <- Timeline.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
