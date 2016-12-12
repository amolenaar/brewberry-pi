defmodule WebTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @moduletag :capture_log

  @opts Brewberry.Router.init([])

  def request(method, path) do
    conn = conn(method, path)
    Brewberry.Router.call(conn, @opts)
  end

  test "/ returns index file" do
    conn = request(:get, "/")

    assert conn.state == :set
    assert conn.status == 301
  end

  test "returns index file" do
    conn = request(:get, "/index.html")

    assert conn.state == :sent
    assert conn.status == 200
    assert String.contains?(conn.resp_body, "<title>Brewberry &pi;</title>")
  end

  test "reads temperature" do
    conn = request(:get, "/temperature")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "{\"mash-temperature\":12}"
  end
end
