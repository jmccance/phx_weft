defmodule Weft.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:content, :string)
    field(:owner_id, :id)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content])
    |> validate_required([:content, :owner_id])
    |> foreign_key_constraint(:owner_id)
  end
end
