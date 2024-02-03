
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
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

Repo.delete_all(Author)

authors = [
  {"Gabriel Garcia Marquez", "Colombia"},
  {"Isabel Allende", "Chile"},
  {"Julio Cortázar", "Argentina"},
  {"Octavio Paz", "Mexico"},
  {"Jorge Luis Borges", "Argentina"},
  {"Laura Esquivel", "Mexico"},
  {"Mario Vargas Llosa", "Peru"},
  {"Pablo Neruda", "Chile"},
  {"Sor Juana Inez de la Cruz", "Mexico"},
  {"Sandra Cisneros", "United States/Mexico"},
  {"Carlos Fuentes", "Mexico"},
  {"Julia de Burgos", "Puerto Rico"},
  {"Juan Rulfo", "Mexico"},
  {"Carmen Laforet", "Spain"},
  {"Rosario Castellanos", "Mexico"},
  {"Alfonsina Storni", "Argentina"},
  {"Federico Garcia Lorca", "Spain"},
  {"Rigoberta Menchú", "Guatemala"},
  {"Carlos Ruiz Zafón", "Spain"},
  {"Ana María Matute", "Spain"},
  {"Laura Restrepo", "Colombia"},
  {"Miguel de Unamuno", "Spain"},
  {"Alfonso Reyes", "Mexico"},
  {"Gioconda Belli", "Nicaragua"},
  {"Jose Marti", "Cuba"},
  {"Juan Carlos Onetti", "Uruguay"},
  {"Luis Alberto Urrea", "United States/Mexico"},
  {"Claribel Alegría", "Nicaragua"},
  {"José Saramago", "Portugal/Spain"},
  {"Carmen Maria Machado", "United States/Cuba"},
]

for {name, origin} <- authors do
  Repo.insert!(%Author{name: name, origin: origin})
end
