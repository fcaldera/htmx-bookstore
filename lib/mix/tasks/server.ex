defmodule Mix.Tasks.Server do
  use Mix.Task

  def run(args) do
    Mix.Tasks.Run.run(args ++ ["--no-halt"])
  end
end
