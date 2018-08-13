defmodule WeftWeb.PostControllerTest do
  use WeftWeb.ConnCase

  alias Plug.Test
  alias Weft.Auth
  alias Weft.Timeline

  @create_attrs %{content: "some content"}
  @invalid_attrs %{content: nil}

  def fixture(:current_user) do
    user_attrs = random_user_attrs()
    {:ok, user} = Auth.create_user(user_attrs)
    user
  end

  defp random_user_attrs do
    suffix = :rand.uniform(100_000)

    %{
      username: "steve#{suffix}",
      email: "steve+#{suffix}@steve.steve",
      password: "surprise! it's steve"
    }
  end

  def fixture(:post, user_id) do
    {:ok, post} = Timeline.create_post(@create_attrs, user_id)
    post
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)

    [
      conn: put_req_header(conn, "accept", "application/json"),
      current_user: current_user
    ]
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, post_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    test "renders post when data is valid",
         %{conn: conn, current_user: %{id: owner_id}} do
      conn = post(conn, post_path(conn, :create), post: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, post_path(conn, :show, id))

      assert match?(
               %{
                 "id" => ^id,
                 "content" => "some content",
                 "owner_id" => ^owner_id,
                 "timestamp" => _
               },
               json_response(conn, 200)["data"]
             )
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, post_path(conn, :create), post: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = delete(conn, post_path(conn, :delete, post))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, post_path(conn, :show, post))
      end)
    end
  end

  defp create_post(_) do
    user = fixture(:current_user)
    post = fixture(:post, user.id)
    {:ok, post: post}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:current_user)

    {
      :ok,
      conn: Test.init_test_session(conn, current_user_id: current_user.id),
      current_user: current_user
    }
  end
end
