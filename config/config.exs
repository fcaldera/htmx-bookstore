import Config

config :book_store,
  ecto_repos: [BookStore.Repo]

config :book_store, BookStore.Repo,
  database: "book_store.db",
  pool_size: 5

