defmodule CheapFlights.Integrations.BritishAirways do
  @moduledoc """
  Client for British Airways
  """
  @behaviour CheapFlights.Behaviours.Integration
  import SweetXml
  alias CheapFlights.Schemas.Dataset

  @provider "ba"
  @endpoint "https://gist.githubusercontent.com/kanmaniselvan/bb11edf031e254977b210c480a0bd89a/raw/ea9bcb65ba4bb2304580d6202ece88aee38540f8/ba_response_sample.xml"

  @impl true
  def load_data do
    response =
      @endpoint
      |> Tesla.get!()
      |> Map.get(:body)

    %Dataset{
      offers: response |> extract_offers(),
      flight_segments: response |> extract_segments()
    }
  end

  defp extract_offers(document) do
    document
    |> xpath(
      ~x"//AirlineOffers/AirlineOffer"l,
      currency: ~x"./TotalPrice/SimpleCurrencyPrice/@Code",
      price: ~x"./TotalPrice/SimpleCurrencyPrice/text()",
      offer_id: ~x"./OfferID/text()",
      segment_ids: ~x"./PricedOffer/Associations/ApplicableFlight/FlightSegmentReference/@ref"l
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_offer(&1, @provider))
    |> Task.await_many()
  end

  defp extract_segments(document) do
    document
    |> xpath(
      ~x"//DataLists/FlightSegmentList/FlightSegment"l,
      segment_id: ~x"./@SegmentKey",
      origin: ~x"./Departure/AirportCode/text()",
      destination: ~x"./Arrival/AirportCode/text()",
      departure_date: ~x"./Departure/Date/text()"
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_segment/1)
    |> Task.await_many()
  end
end
