defmodule CheapFlights.Integrations.BritishAirways do
  @moduledoc """
  Client for British Airways
  """
  import SweetXml

  @behaviour CheapFlights.Behaviours.Integration
  @provider "ba"
  @endpoint "https://gist.githubusercontent.com/kanmaniselvan/bb11edf031e254977b210c480a0bd89a/raw/ea9bcb65ba4bb2304580d6202ece88aee38540f8/ba_response_sample.xml"

  @impl true
  def load_data do
    @endpoint
    |> Tesla.get!()
    |> Map.get(:body)
    |> xpath(
      ~x"//AirlineOffers/AirlineOffer"l,
      currency: ~x"./TotalPrice/SimpleCurrencyPrice/@Code",
      price: ~x"./TotalPrice/SimpleCurrencyPrice/text()",
      offer_id: ~x"./OfferID/text()",
      segment_id: ~x"./PricedOffer/Associations/ApplicableFlight/FlightSegmentReference/@ref"l
    )
    |> Enum.map(&CheapFlights.Helpers.prepare_data(&1, @provider))
    |> Task.await_many()
  end
end
