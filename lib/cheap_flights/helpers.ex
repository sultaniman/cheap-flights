defmodule CheapFlights.Helpers do
  @moduledoc """
  Helpers to prepare data and parallelize requests
  """
  alias CheapFlights.Schemas.{FlightSegment, Offer}

  @spec prepare_offer(map(), String.t()) :: Task.t()
  def prepare_offer(offer, provider) do
    Task.async(fn ->
      %Offer{
        provider: provider |> to_string(),
        currency: offer.currency |> to_string(),
        price: offer.price |> to_string() |> String.to_float(),
        offer_id: offer.offer_id |> to_string(),
        segment_ids: offer.segment_ids |> Enum.uniq() |> Enum.map(&to_string(&1))
      }
    end)
  end

  @spec prepare_segment(map()) :: Task.t()
  def prepare_segment(segment) do
    Task.async(fn ->
      %FlightSegment{
        origin: segment.origin |> to_string(),
        destination: segment.destination |> to_string(),
        segment_id: segment.segment_id |> to_string(),
        departure_date: segment.departure_date |> to_string()
      }
    end)
  end

  @spec fetch_async(any) :: Task.t()
  def fetch_async(client) do
    Task.async(fn ->
      client.load_data()
    end)
  end

  @doc """
  Lookup flight segments by origing, destination and date
  NOTE: It is naive assumption dates a valid and in string format YYYY-MM-DD.
  Returns the list of segment ids.
  """
  @spec lookup_segments([FlightSegment.t()], String.t(), String.t(), String.t()) :: [String.t()]
  def lookup_segments(segments, origin, destination, date) do
    # First lookup by origin and destination
    filtered_segments =
      segments
      |> Enum.filter(fn segment ->
        segment.origin == origin && segment.destination == destination
      end)

    # Then if date is given then extract segment_ids for matching dates
    # Else just extract segment_ids
    if not is_nil(date) do
      filtered_segments
      |> Enum.filter(&String.starts_with?(&1.departure_date, date))
      |> Enum.map(&Map.get(&1, :segment_id))
    else
      filtered_segments
      |> Enum.map(&Map.get(&1, :segment_id))
    end
  end

  @doc """
  Lookup offers for given segment ids and group them by price
  Then order by price and take the first price and return offers for it
  """
  @spec lookup_offers([Offer.t()], [String.t()]) :: map | nil
  def lookup_offers(offers, segment_ids) do
    results =
      segment_ids
      |> Enum.map(fn segment_id ->
        offers
        |> Enum.filter(&Enum.member?(&1.segment_ids, segment_id))
      end)
      |> List.flatten()
      |> Enum.group_by(& &1.price)

    key =
      results
      |> Map.keys()
      |> Enum.sort(:asc)
      |> Enum.at(0)

    if not is_nil(key) do
      results
      |> Map.get(key, [])
    else
      []
    end
  end
end
