defmodule LiveTcp.ServerTest do
  use ExUnit.Case
  doctest LiveTcp.Server

  test "greets the world" do
    assert LiveTcp.Server.hello() == :world
  end
end
