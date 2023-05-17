import Config


config :cheap_flights,
  integrations: [
    CheapFlights.Integrations.BritishAirways,
    CheapFlights.Integrations.AirFrance
  ]

config :cheap_flights, CheapFlights.Scheduler,
  jobs: [
    # Update every minute
    {"* * * * *", {CheapFlights.Aggregator, :update, []}},
  ]

import_config "#{config_env()}.exs"
