defmodule Weft.TimelineTest do
  use Weft.DataCase

  alias Weft.Auth
  alias Weft.Timeline

  describe "posts" do
    alias Weft.Timeline.Post

    @valid_attrs %{content: "some content"}
    @invalid_attrs %{content: nil}

    def user_fixture() do
      {:ok, current_user} =
        Auth.create_user(%{
          username: "steve",
          email: "steve@steve.steve",
          password: "also steve"
        })

      current_user
    end

    def post_fixture(attrs \\ %{}) do
      current_user = user_fixture()

      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Timeline.create_post(current_user.id)

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Timeline.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Timeline.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()

      assert {:ok, %Post{} = post} = Timeline.create_post(@valid_attrs, user.id)
      assert post.content == "some content"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_post(@invalid_attrs)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Timeline.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Timeline.change_post(post)
    end
  end
end
