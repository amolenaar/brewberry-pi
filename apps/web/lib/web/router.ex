defmodule Web.Router do
  use Plug.Router
  require Logger

  @moduledoc false

  if Mix.env == :dev do
    use Plug.Debugger
  end

  plug Plug.Logger
  plug Web.Redirects
  plug Plug.Static, at: "/", from: :web

  plug Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/temperature" do
    send_last_value conn, fn sample -> %{"mash-temperature" => sample.mash_temperature} end
  end

  post "/temperature" do
    new_temperature = conn.params["set"]
    Ctrl.ControllerServer.mash_temperature(new_temperature)
    send_resp(conn, 200, Poison.encode!(%{"mash-temperature" => new_temperature}))
  end

  get "/controller" do
    send_last_value conn, fn sample -> %{"controller" => sample.mode} end
  end

  post "/controller" do
    new_controller_state = conn.params["set"]
    if new_controller_state == "on" do
      Ctrl.ControllerServer.resume
    else
      Ctrl.ControllerServer.pause
    end
    send_resp(conn, 200, Poison.encode!(%{"controller" => new_controller_state}))
  end

  get "/logger" do
    last_event_id = case get_req_header(conn, "last-event-id") do
      [id] -> String.to_integer id
      _ -> 0
    end

    IO.puts "last event id: #{inspect last_event_id}"

    conn
    |> put_resp_header("content-type", "text/event-stream")
    |> send_chunked(200)
    |> send_past_events(last_event_id)
    |> send_events()
  end

  defp send_last_value(conn, callback) do
    case Ctrl.TimeSeries.last do
      {_id, sample} -> send_resp(conn, 200, Poison.encode!(callback.(sample)))
      :no_data      -> send_resp(conn, 200, "{}")
    end
  end

  defp send_past_events(conn, last_event_id) do
    chunk(conn,
      last_event_id
      |> Ctrl.TimeSeries.get_series
      |> encode_events
    )
    conn
   end

  defp send_events(conn) do
    Ctrl.TimeSeries.stream
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
