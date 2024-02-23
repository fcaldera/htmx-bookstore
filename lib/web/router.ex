defmodule BookStore.Router do
  use Plug.Router
  require EEx

  import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  alias BookStore.Book
  alias BookStore.Repo
  alias BookStore.Author

  # Load templates from files
  EEx.function_from_file(:def, :layout, "lib/web/layout.html.eex", [:assigns])
  EEx.function_from_file(:def, :index, "lib/web/index.html.eex", [:assigns])
  EEx.function_from_file(:def, :author_index, "lib/web/author/index.html.eex", [:assigns])
  EEx.function_from_file(:def, :author_show, "lib/web/author/show.html.eex", [:assigns])
  EEx.function_from_file(:def, :author_new, "lib/web/author/new.html.eex", [:assigns])
  EEx.function_from_file(:def, :author_edit, "lib/web/author/edit.html.eex", [:assigns])
  EEx.function_from_file(:def, :book_index, "lib/web/book/index.html.eex", [:assigns])

  if Mix.env() == :dev do
    use Plug.Debugger
    # use Plug.Debugger, style: [primary: "#c0392b", accent: "#41B577"]
  end

  # use Plug.ErrorHandler

  plug Plug.Logger

  plug Plug.Static,
    at: "/",
    from: :book_store,
    only: ["assets", "images", "favicon.ico"]

  plug :match
  # plug(:put_secret_key_base)
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  # plug(Plug.Session, store: :cookie, key: "_daze_app", signing_salt: "daze salt")
  # plug(:fetch_session)
  plug :dispatch

  def redirect(conn, to) do
    conn
    |> Plug.Conn.put_resp_header("location", to)
    |> Plug.Conn.resp(301, "You are being redirected.")
    |> Plug.Conn.halt()
  end

  def render(conn, template, assigns \\ []) do
    inner_content = apply(__MODULE__, template, [assigns])
    page_content = apply(__MODULE__, :layout, [[{:inner_content, inner_content} | assigns]])

    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, page_content)
  end

  get "/" do
    redirect(conn, "/books")
  end

  get "/books" do
    # For more efficiency:
    # query =
    #   from b in Book,
    #     join: a in Author,
    #     on: a.id == b.author_id,
    #     select: %{
    #       id: b.id,
    #       title: b.title,
    #       publisher: b.publisher,
    #       year: b.year,
    #       author: %{id: a.id, name: a.name}
    #     }

    query = from b in Book, preload: :author
    books = Repo.all(query)
    render(conn, :book_index, books: books, params: conn.params)
  end

  get "/authors" do
    # query = from a in Author, select: {a.id, a.name, a.origin}
    authors = Repo.all(Author)
    render(conn, :author_index, authors: authors)
  end

  get "/authors/new" do
    changeset = Author.changeset(%Author{})
    render(conn, :author_new, changeset: changeset)
  end

  post "authors/new" do
    result =
      %Author{}
      |> Author.changeset(conn.body_params)
      |> Repo.insert()

    case result do
      {:ok, _author} ->
        redirect(conn, "/authors")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :author_new, changeset: changeset)
    end
  end

  get "/authors/:id" do
    author = Repo.get!(Author, id)
    render(conn, :author_show, author: author)
  end

  get "/authors/:id/edit" do
    author = Repo.get!(Author, id)
    changeset = Author.changeset(author)
    render(conn, :author_edit, changeset: changeset)
  end

  post "authors/:id/edit" do
    result =
      Repo.get!(Author, id)
      |> Author.changeset(conn.body_params)
      |> Repo.update()

    case result do
      {:ok, author} ->
        redirect(conn, "/authors/#{author.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :author_edit, changeset: changeset)
    end
  end

  get "/authors/:id/delete" do
    author = Repo.get!(Author, id)
    {:ok, _author} = Repo.delete(author)

    redirect(conn, "/authors")
  end
end
