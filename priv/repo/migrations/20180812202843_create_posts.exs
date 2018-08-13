defmodule Weft.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:content, :string)
      add(:owner_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:posts, [:owner_id]))
  end
end
