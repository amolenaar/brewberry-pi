defmodule Brewberry.Router do
  use Plug.Router

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
    put_resp_header(conn, "content-type", "text/event-stream")
    |> send_chunked(200)
    |> send_events
  end

  defp send_events(conn, id \\ 0) do
    send_message(conn, id, Brewberry.ControllerLoop.state?)
    :timer.sleep(1000)

    send_events(conn, id + 1)
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
