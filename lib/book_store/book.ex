defmodule BookStore.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :isbn, :string
    field :title, :string
    field :publisher, :string
    field :price, :decimal
    field :year, :integer

    belongs_to :author, BookStore.Author

    timestamps()
  end

  def changeset(book, params \\ %{}) do
    book
    |> cast(params, [:isbn, :title, :publisher, :price, :year, :author_id])
    |> validate_required([:isbn, :title], message: "This field is required.")
    |> validate_number(:year, greater_than_or_equal_to: 0, less_than: 9999)
    |> validate_number(:price, greater_than_or_equal_to: 0, less_than: 10000)
  end
end
