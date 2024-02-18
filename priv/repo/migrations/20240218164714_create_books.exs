defmodule BookStore.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :isbn, :string
      add :title, :string
      add :publisher, :string
      add :price, :decimal, precision: 7, scale: 2
      add :year, :integer

      add :author_id, references(:authors, on_delete: :restrict)

      timestamps()
    end

    create unique_index(:books, [:isbn])
  end
end
