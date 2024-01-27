defmodule BookStoreTest do
  use ExUnit.Case
  doctest BookStore

  test "greets the world" do
    assert BookStore.hello() == :world
  end
end
