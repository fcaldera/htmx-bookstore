defmodule BookStore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting server at http://localhost:4000/")

    children = [
      # Starts a worker by calling: BookStore.Worker.start_link(arg)
      # {BookStore.Worker, arg}
      BookStore.Repo,
      {Plug.Cowboy, scheme: :http, plug: BookStore.Router, port: 4000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BookStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
