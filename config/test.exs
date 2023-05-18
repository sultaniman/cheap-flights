import Config

config :cheap_flights,
  integrations: [CheapFlights.Integrations.BritishAirways]

config :exvcr, :vcr_cassette_library_dir, "test/fixtures/cassettes"
