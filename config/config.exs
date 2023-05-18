import Config

config :cheap_flights,
  integrations: [
    CheapFlights.Integrations.BritishAirways,
    CheapFlights.Integrations.AirFrance
  ]

config :cheap_flights, server_port: 8080

config :cheap_flights, CheapFlights.Scheduler,
  jobs: [
    # Update every minute
    {"*/5 * * * *", {CheapFlights.Aggregator, :update, []}}
  ]

config :tesla, :adapter, Tesla.Adapter.Hackney

import_config "#{config_env()}.exs"
