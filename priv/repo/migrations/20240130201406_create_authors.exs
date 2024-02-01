defmodule BookStore.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add(:name, :string)
      add(:bio, :string)
      add(:picture, :string)

      timestamps()
    end
  end
end
