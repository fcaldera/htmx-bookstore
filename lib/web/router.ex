defmodule BookStore.Router do
  use Plug.Router
  require EEx

  import Ecto.Query, only: [from: 2]

  alias BookStore.Repo
  alias BookStore.Author

  # Load templates from files
  EEx.function_from_file(:def, :layout, "lib/web/layout.html.eex", [:assigns])
  EEx.function_from_file(:def, :index, "lib/web/index.html.eex", [:assigns])
  EEx.function_from_file(:def, :author_index, "lib/web/author/index.html.eex", [:assigns])

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
    render(conn, :index, message: "Hello")
  end

  get "/authors" do
    # query = from a in Author, select: {a.id, a.name, a.origin}
    authors = Repo.all(Author)

    render(conn, :author_index, authors: authors)
  end
end
