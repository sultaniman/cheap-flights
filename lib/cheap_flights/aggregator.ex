defmodule CheapFlights.Aggregator do
  @moduledoc false
  use GenServer
  require Logger
  @module __MODULE__

  # Client API
  def start_link(_) do
    GenServer.start_link(@module, {}, name: @module)
  end

  @spec update :: any()
  def update do
    GenServer.cast(@module, :update)
  end

  # Server callbacks
  @impl true
  def init(_) do
    # Return empty tuple which later will be populated
    # with fetched and parsed data from flights data source
    # first item in the tuple will be offers
    # second is the list of flight segments to cross match
    # third is a mapping of segments by segment id
    {:ok, {}, {:continue, :load_data}}
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
