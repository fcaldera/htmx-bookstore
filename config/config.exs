import Config

config :book_store,
  ecto_repos: [BookStore.Repo]

config :book_store, BookStore.Repo,
  # database: "book_store.db",
  database: Path.expand("../book_store_#{Mix.env()}.db", Path.dirname(__ENV__.file)),
  pool_size: 5
