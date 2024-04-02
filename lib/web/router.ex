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
  EEx.function_from_file(:def, :book_show, "lib/web/book/show.html.eex", [:assigns])
  EEx.function_from_file(:def, :book_edit, "lib/web/book/edit.html.eex", [:assigns])
  EEx.function_from_file(:def, :book_list, "lib/web/book/list.html.eex", [:assigns])

  if Mix.env() == :dev do
    use Plug.Debugger
    # use Plug.Debugger, style: [primary: "#c0392b", accent: "#41B577"]
  end

  # use Plug.ErrorHandler

  plug Plug.Logger

  plug Plug.Static,
    at: "/",
    from: :book_store,
    only: ["assets", "images", "favicon.ico", "vendor"]

  plug :match
  # plug(:put_secret_key_base)
  plug Plug.Parsers, parsers: [:urlencoded, :multipart]
  # plug(Plug.Session, store: :cookie, key: "_daze_app", signing_salt: "daze salt")
  # plug(:fetch_session)
  plug :dispatch

  def redirect(conn, to, status \\ 301) do
    conn
    |> Plug.Conn.put_resp_header("location", to)
    |> Plug.Conn.resp(status, "You are being redirected.")
    |> Plug.Conn.halt()
  end

  def render(conn, template, assigns \\ []) do
    inner_content = apply(__MODULE__, template, [assigns])
    page_content = apply(__MODULE__, :layout, [[{:inner_content, inner_content} | assigns]])

    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, page_content)
  end

  def partial(conn, template, assigns \\ []) do
    page_content = apply(__MODULE__, template, [assigns])
    
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> Plug.Conn.send_resp(200, page_content)
  end

  get "/" do
    redirect(conn, "/books")
  end

  get "/books" do
    search = "%#{conn.params["q"]}%"
    page = String.to_integer(conn.params["page"] || "1")
    size = 8

    query =
      from b in Book,
        join: a in Author,
        on: a.id == b.author_id,
        where: like(b.title, ^search) or like(b.publisher, ^search) or like(a.name, ^search),
        select: %{
          id: b.id,
          title: b.title,
          publisher: b.publisher,
          year: b.year,
          author: %{id: a.id, name: a.name}
        },
        limit: ^size,
        offset: ^((page - 1) * size)

    books = Repo.all(query)

    data = [
      books: books,
      params: conn.params,
      pagination: %{
        prev: (if page == 1, do: nil, else: page - 1),
        next: (if length(books) < size, do: nil, else: page + 1)
      },
    ]

    case get_req_header(conn, "hx-trigger") do
      ["search"] -> 
        partial(conn, :book_list, data)

      _  -> 
        render(conn, :book_index, data)
    end

  end

  get "/books/:id" do
    query = 
      from b in Book,
        join: a in Author,
        on: a.id == b.author_id,
        where: b.id == ^id,
        select: %{
          id: b.id,
          title: b.title,
          publisher: b.publisher,
          year: b.year,
          author: %{id: a.id, name: a.name},
          price: b.price,
          isbn: b.isbn
        }
      
    book = Repo.one!(query)
    render(conn, :book_show, book: book)     
  end
  
  get "/books/:id/edit" do
    book = Repo.get!(Book, id)
    
    qa = from a in Author, 
      select: %{id: a.id, name: a.name},
      order_by: :name

    authors = Repo.all(qa)
    changeset = Book.changeset(book)
    render(conn, :book_edit, changeset: changeset, authors: authors)
  end

  post "/books/:id/edit" do
    result = 
      Repo.get!(Book, id)
      |> Book.changeset(conn.body_params)
      |> Repo.update()

    case result do
      {:ok, book} -> 
        redirect(conn, "/books/#{book.id}")
      
      {:error, %Ecto.Changeset{} = changeset} -> 
        render(conn, :book_edit, changeset: changeset)
    end
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

  delete "/authors/:id" do
    author = Repo.get!(Author, id)
    {:ok, _author} = Repo.delete(author)

    redirect(conn, "/authors", 303)
  end
end
