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
end
