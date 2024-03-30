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

Repo.delete_all(Book)

add_books = fn name, books -> 
  author_id = name |> Authors.by_name() |> Repo.one() 

  for {title, isbn, publisher, year, price} <- books do
    Repo.insert!(%Book{
      title: title,
      isbn: isbn,
      publisher: publisher,
      year: year,
      price: price,
      author_id: author_id
    })
  end
end

add_books.("Gabriel Garcia Marquez", [
  {"One Hundred Years of Solitude", "978-0060883287", "Harper Perennial Modern Classics", 2006, 10.99},
  {"Love in the Time of Cholera", "978-0307389732", "Vintage", 2007, 9.99},
  {"Chronicle of a Death Foretold", "978-1400034710", "Vintage", 2003, 8.99},
  {"Of Love and Other Demons", "978-1400034925", "Vintage", 2008, 11.99},
  {"The Autumn of the Patriarch", "978-0060882860", "Harper Perennial Modern Classics", 2006, 12.99}
])

add_books.("Isabel Allende", [
  {"The House of the Spirits","978-0553383805","Vintage",2005,10.99},
  {"Eva Luna","978-0553383829","Washington Square Press",2006,9.99},
  {"Paula","978-0061564901","Harper Perennial",2008,11.99},
  {"Island Beneath the Sea","978-0061988256","Harper Perennial",2011,12.99},
  {"The Japanese Lover","978-1501116971","Atria Books",2016,13.99},
])

add_books.("Julio Cortázar", [
  {"Hopscotch","978-0394752848","Pantheon",1987,10.99},
  {"Blow-Up and Other Stories","978-0394728812","Pantheon",1985,9.99},
  {"The Winners","978-0394728843","Pantheon",1985,8.99},
  {"Final Exam","978-0811217241","New Directions",2000,11.99},
  {"Rayuela","978-8437606601","Cátedra",2008,12.99},
])

add_books.("Octavio Paz", [
  {"The Collected Poems of Octavio Paz: 1957-1987","978-0811211454","New Directions",1991,9.99},
  {"In Light of India","978-0151001006","Harcourt Brace",1997,8.99},
  {"The Double Flame: Love and Eroticism","978-0156003656","Mariner Books",1996,11.99},
])

add_books.("Jorge Luis Borges", [
  {"Ficciones","978-0802130303","Grove Press",1998,10.99},
  {"Labyrinths: Selected Stories and Other Writings","978-0811216992","New Directions",2007,9.99},
  {"The Aleph and Other Stories","978-0142437889","Penguin Classics",2000,8.99},
  {"The Book of Sand","978-0142003868","Penguin Books",2005,11.99},
  {"The Library of Babel","978-1598184022","Aegypan",2006,12.99},
])

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
