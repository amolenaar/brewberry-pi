defmodule Brewberry.Router do
  use Plug.Router

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger
  plug Brewberry.Redirects
  plug Plug.Static, at: "/", from: :web
  plug Plug.Parsers, parsers: [:urlencoded, :json]
  plug :match
  plug :dispatch

  get "/temperature" do
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => 12}))
  end

  post "/temperature" do
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature": 12}))
  end

  get "/controller" do
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature": 12}))
  end

  post "/controller" do
    send_resp(conn, 200, Poison.encode!(%{ "mash-temperature": 12}))
  end

  get "/logger" do
    id = 12
    data = 12
    send_resp(conn, 200, "id: #{id}\nevent: sample\ndata: #{data}\n\n")
  end

  # catch-all
  match _ do
    send_resp(conn, 404, "Resource not found")
  end

end
