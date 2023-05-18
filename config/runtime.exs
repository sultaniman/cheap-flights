import Config

config :cheap_flights, server_port: System.get_env("PORT", "8080") |> String.to_integer()
