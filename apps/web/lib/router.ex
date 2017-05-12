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
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => Brewberry.ControllerLoop.state?().mash_temperature}))
  end

  post "/temperature" do
    new_temperature = conn.params["set"]
    Brewberry.MashTemperature.set!(new_temperature)
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => new_temperature}))
  end

  get "/controller" do
    send_resp(conn, 200, Poison.encode!(%{"controller" => Brewberry.ControllerLoop.state?().mode}))
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
    last_event_id = case get_req_header(conn, "last-event-id") do
      [id] -> String.to_integer id
      _ -> 0
    end

    IO.puts "last event id: #{inspect last_event_id}"

    put_resp_header(conn, "content-type", "text/event-stream")
    |> send_chunked(200)
    |> send_past_events(last_event_id)
    |> send_events()
  end

  defp send_past_events(conn, last_event_id) do
    chunk(conn,
      Brewberry.TimeSeries.get_series(last_event_id)
      |> encode_events
    )
    conn
   end

  defp send_events(conn) do
    # TODO: Start a server to handle sample events?
    Brewberry.Dispatcher.stream
    |> Enum.reduce_while(nil, fn {id, sample}, _acc ->
         case chunk(conn, encode_event({id, sample})) do
           {:ok, _}    -> {:cont, nil}
           {:error, _} -> {:halt, conn}
         end
       end)
  end

  defp encode_event({id, data}),
   do: "id: #{id}\nevent: sample\ndata: #{Poison.encode!(data)}\n\n"

  defp encode_events([]) do
    ""
  end

  defp encode_events(events) do
    {last_id, _last_data} = List.last(events)
    {:ok, event_data} = events |> Enum.map(fn {_id, data} -> data end) |> Poison.encode
    "id: #{last_id}\nevent: samples\ndata: #{event_data}\n\n"
  end

  # catch-all
  match _ do
    send_resp(conn, 404, "Resource not found")
  end

end
