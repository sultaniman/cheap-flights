defmodule CheapFlights.Integrations.AirFrance do
  @moduledoc """
  Client for Air France
  """
  import SweetXml

  @behaviour CheapFlights.Behaviours.Integration
  @provider "ba"
  @endpoint "https://gist.githubusercontent.com/kanmaniselvan/bb11edf031e254977b210c480a0bd89a/raw/ea9bcb65ba4bb2304580d6202ece88aee38540f8/afklm_response_sample.xml"

  @impl true
  def load_data do
    @endpoint
    |> Tesla.get!()
    |> Map.get(:body)
    |> xpath(
      ~x"//ns2:OffersGroup/ns2:CarrierOffers/ns2:Offer"l,
      currency: ~x"./ns2:OfferItem/ns2:Price/ns2:TotalAmount/@CurCode",
      price: ~x"./ns2:OfferItem/ns2:Price/ns2:TotalAmount/text()",
      offer_id: ~x"./ns2:OfferID/text()",
      segment_id: ~x"./ns2:OfferItem/ns2:FareDetail/ns2:FareComponent/ns2:PaxSegmentRefID/text()"l
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_data(&1, @provider))
    |> Task.await_many()
  end
end
