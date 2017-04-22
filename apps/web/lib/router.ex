defmodule Brewberry.Router do
  use Plug.Router
  require Logger

  @moduledoc false

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
    Brewberry.MashTemperature.set!(new_temperature)
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => new_temperature}))
  end

  get "/controller" do
    send_resp(conn, 200, Poison.encode!(%{"controller" => "Idle"}))
  end

  post "/controller" do
    new_controller_state = conn.params["set"]
    if new_controller_state == "on" do
      Brewberry.Controller.resume
    else
      Brewberry.Controller.pause
    end
    send_resp(conn, 200, Poison.encode!(%{"controller" => new_controller_state}))
  end

  get "/logger" do
    last_event_id = get_req_header(conn, "last-event-id") || 0
    IO.puts "last event id: #{last_event_id}"

    put_resp_header(conn, "content-type", "text/event-stream")
    |> send_chunked(200)
    |> send_events(last_event_id)
  end

  defp send_events(conn, id) do
    Brewberry.Ctrl.stream
    |> Enum.reduce_while(nil, fn {id, sample}, _acc ->
         case send_message(conn, id, sample) do
           {:ok, _}    -> {:cont, nil}
           {:error, _} -> {:halt, conn}
         end
       end)
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
