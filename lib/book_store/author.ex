defmodule BookStore.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field(:name, :string)
    field(:bio, :string)
    field(:picture, :string)

    timestamps()
  end


  def changeset(author, params \\ %{}) do
    author
    |> cast(params, [:name, :bio, :picture])
    |> validate_required([:name])
  end
end
