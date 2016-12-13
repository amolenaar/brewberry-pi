defmodule Brewberry.Router do
  use Plug.Router
  alias Brewberry.Sample

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger
  plug Brewberry.Redirects
  plug Plug.Static, at: "/", from: :web

  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/temperature" do
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => 12}))
  end

  post "/temperature" do
    new_temperature = conn.params["set"]
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => new_temperature}))
  end

  get "/controller" do
    send_resp(conn, 200, Poison.encode!(%{"controller" => "Idle"}))
  end

  post "/controller" do
    new_controller_state = conn.params["set"]
    send_resp(conn, 200, Poison.encode!(%{ "controller" => new_controller_state}))
  end

  get "/logger" do
    put_resp_header(conn, "content-type", "text/event-stream")
    |> send_chunked(200)
    |>send_events
  end

  defp send_events(conn, id \\ 0) do
    data = %Sample{
      :time => local_iso_date,
      :temperature => 12,
      :heater => false,
      :controller => "Live",
      :"mash-temperature" => 60
    }

    send_message(conn, id, data)
    :timer.sleep(1000)

    send_events(conn, id + 1)
  end

  defp local_iso_date do
    DateTime.utc_now() |> DateTime.to_naive() |> NaiveDateTime.to_iso8601()
  end

  defp send_message(conn, id, data) do
    encoded_data = Poison.encode!(data)
    chunk(conn, "id: #{id}\nevent: sample\ndata: #{encoded_data}\n\n")
  end

  # catch-all
  match _ do
    send_resp(conn, 404, "Resource not found")
  end

end
