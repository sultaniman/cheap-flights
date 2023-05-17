defmodule CheapFlights.Integrations.AirFrance do
  @moduledoc """
  Client for Air France
  """
  @behaviour CheapFlights.Behaviours.Integration
  import SweetXml
  alias CheapFlights.Schemas.Dataset

  @provider "ba"
  @endpoint "https://gist.githubusercontent.com/kanmaniselvan/bb11edf031e254977b210c480a0bd89a/raw/ea9bcb65ba4bb2304580d6202ece88aee38540f8/afklm_response_sample.xml"

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
      ~x"//ns2:OffersGroup/ns2:CarrierOffers/ns2:Offer"l,
      currency: ~x"./ns2:OfferItem/ns2:Price/ns2:TotalAmount/@CurCode",
      price: ~x"./ns2:OfferItem/ns2:Price/ns2:TotalAmount/text()",
      offer_id: ~x"./ns2:OfferID/text()",
      segment_ids:
        ~x"./ns2:OfferItem/ns2:FareDetail/ns2:FareComponent/ns2:PaxSegmentRefID/text()"l
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_offer(&1, @provider))
    |> Task.await_many()
  end

  defp extract_segments(document) do
    document
    |> xpath(
      ~x"//ns2:DataLists/ns2:PaxSegmentList/ns2:PaxSegment"l,
      segment_id: ~x"./ns2:PaxSegmentID/text()",
      origin: ~x"./ns2:Dep/ns2:IATALocationCode/text()",
      destination: ~x"./ns2:Arrival/ns2:IATALocationCode/text()",
      departure_date: ~x"./ns2:Dep/ns2:AircraftScheduledDateTime/text()"
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_segment/1)
    |> Task.await_many()
  end
end
