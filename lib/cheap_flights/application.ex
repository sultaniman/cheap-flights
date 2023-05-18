defmodule CheapFlights.Application do
  @moduledoc false
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    server_port = Application.get_env(:cheap_flights, :server_port)

    children = [
      CheapFlights.Aggregator,
      CheapFlights.Scheduler,
      {
        Plug.Cowboy,
        scheme: :http, plug: CheapFlights.Api.Router, options: [port: server_port]
      }
    ]

    Logger.info("Server started at http://localhost:#{server_port}")

    opts = [strategy: :one_for_one, name: CheapFlights.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
