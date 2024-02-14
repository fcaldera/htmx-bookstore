defmodule BookStore.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field(:name, :string)
    field(:bio, :string)
    field(:picture, :string)
    field(:origin, :string)

    timestamps()
  end

  def changeset(author, params \\ %{}) do
    author
    |> cast(params, [:name, :bio, :picture, :origin])
    |> validate_required([:name, :origin], message: "This field is required.")
  end
end
