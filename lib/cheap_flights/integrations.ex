defmodule CheapFlights.Integrations do
  @moduledoc """
  Integrations handler implements logic to fetch
  and parse offers via all available integrations.
  """
  alias CheapFlights.Helpers

  def load_data do
    Application.get_env(:cheap_flights, :integrations)
    |> Enum.map(&Helpers.fetch_async/1)
    |> Task.await_many()
  end
end
