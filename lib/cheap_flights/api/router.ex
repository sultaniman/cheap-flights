defmodule CheapFlights.Api.Router do
  @moduledoc """
  Simple Plug API router
  """
  use Plug.Router
  alias CheapFlights.Api.Helpers
  alias CheapFlights.Aggregator

  plug(Plug.Logger)
  plug(Plug.Static, at: "/", from: "assets")
  plug(:match)

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/findCheapestOffer" do
    params =
      conn
      |> fetch_query_params()
      |> Map.get(:query_params)
      |> Helpers.validate_params()

    case params do
      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: message}))

      {origin, destination, date} ->
        {status_code, response} =
          Aggregator.lookup(origin, destination, date)
          |> Helpers.prepare_response()

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(status_code, response)
    end
  end

  match _ do
    send_resp(
      conn,
      404,
      "Oi bruv moo innit! https://twitter.com/PicturesFoIder/status/1655257717857046530?s=20"
    )
  end
end
