# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds_books.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BookStore.Repo.insert!(%BookStore.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong

alias BookStore.Repo
alias BookStore.Author
alias BookStore.Book

import Ecto.Query, only: [from: 2]

defmodule Authors do
  def by_name(name) do
    from a in Author,
      where: a.name == ^name,
      select: a.id
  end
end

# Repo.delete_all(Book)

books = [
  {"One Hundred Years of Solitude", "978-0060883287", "Harper Perennial Modern Classics", 2006, 10.99},
  {"Love in the Time of Cholera", "978-0307389732", "Vintage", 2007, 9.99},
  {"Chronicle of a Death Foretold", "978-1400034710", "Vintage", 2003, 8.99},
  {"Of Love and Other Demons", "978-1400034925", "Vintage", 2008, 11.99},
  {"The Autumn of the Patriarch", "978-0060882860", "Harper Perennial Modern Classics", 2006, 12.99}
]

gabo = Repo.one(Authors.by_name("Gabriel Garcia Marquez"))

for {title, isbn, publisher, year, price} <- books do
  Repo.insert!(%Book{
    title: title,
    isbn: isbn,
    publisher: publisher,
    year: year,
    price: price,
    author_id: gabo
  })
end

# authors = [
#   {"Gabriel Garcia Marquez", "Colombia"},
#   {"Isabel Allende", "Chile"},
#   {"Julio Cortázar", "Argentina"},
#   {"Octavio Paz", "Mexico"},
#   {"Jorge Luis Borges", "Argentina"},
#   {"Laura Esquivel", "Mexico"},
#   {"Mario Vargas Llosa", "Peru"},
#   {"Pablo Neruda", "Chile"},
#   {"Sor Juana Inez de la Cruz", "Mexico"},
#   {"Sandra Cisneros", "United States/Mexico"},
#   {"Carlos Fuentes", "Mexico"},
#   {"Julia de Burgos", "Puerto Rico"},
#   {"Juan Rulfo", "Mexico"},
#   {"Carmen Laforet", "Spain"},
#   {"Rosario Castellanos", "Mexico"},
#   {"Alfonsina Storni", "Argentina"},
#   {"Federico Garcia Lorca", "Spain"},
#   {"Rigoberta Menchú", "Guatemala"},
#   {"Carlos Ruiz Zafón", "Spain"},
#   {"Ana María Matute", "Spain"},
#   {"Laura Restrepo", "Colombia"},
#   {"Miguel de Unamuno", "Spain"},
#   {"Alfonso Reyes", "Mexico"},
#   {"Gioconda Belli", "Nicaragua"},
#   {"Jose Marti", "Cuba"},
#   {"Juan Carlos Onetti", "Uruguay"},
#   {"Luis Alberto Urrea", "United States/Mexico"},
#   {"Claribel Alegría", "Nicaragua"},
#   {"José Saramago", "Portugal/Spain"},
#   {"Carmen Maria Machado", "United States/Cuba"},
# ]
#
