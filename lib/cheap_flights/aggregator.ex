defmodule CheapFlights.Aggregator do
  @moduledoc false
  use GenServer
  require Logger
  alias CheapFlights.Helpers

  @module __MODULE__

  # 2 minute expiration
  @cache_ttl_minutes 2

  # Client API
  def start_link(_) do
    GenServer.start_link(@module, {}, name: @module)
  end

  @spec update :: any()
  def update do
    GenServer.cast(@module, :update)
  end

  @spec lookup(String.t(), String.t(), String.t() | nil) :: any()
  def lookup(origin, destination, date) do
    cache_key = Enum.join([origin, destination, date], "::")

    case Cachex.get(:cheap_flights, cache_key) do
      {:ok, nil} ->
        cheapest_offer = GenServer.call(@module, {:lookup, origin, destination, date})

        Cachex.put(:cheap_flights, cache_key, cheapest_offer,
          ttl: :timer.minutes(@cache_ttl_minutes)
        )

        cheapest_offer

      {:ok, cheapest_offer} ->
        cheapest_offer
    end
  end

  # Server callbacks
  @impl true
  def init(_) do
    # Return empty tuple which later will be populated
    # with fetched and parsed data from flights data source
    # first item in the tuple will be offers
    # second is the list of flight segments to cross match
    {:ok, {}, {:continue, :load_data}}
  end

  @impl true
  def handle_call(
        {:lookup, origin, destination, date},
        _from,
        {offers, segments} = state
      ) do
    # First lookup by origin and destination
    filtered_segments =
      segments
      |> Helpers.lookup_segments(origin, destination, date)

    cheapest_offer =
      offers
      |> Helpers.lookup_offers(filtered_segments)
      |> Enum.at(0)

    {:reply, cheapest_offer, state}
  end

  @impl true
  def handle_cast(:update, _state) do
    Logger.info("Updating flight data")
    {:noreply, CheapFlights.Integrations.load_data()}
  end

  @impl true
  def handle_continue(:load_data, _state) do
    Logger.info("Loading initial flight data")
    {:noreply, CheapFlights.Integrations.load_data()}
  end
end
