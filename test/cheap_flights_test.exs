defmodule CheapFlightsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias CheapFlights.Schemas.Offer

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/cassettes")
    :ok
  end

  test "clients work as expected" do
    use_cassette "british airways client" do
      data = CheapFlights.Integrations.BritishAirways.load_data()
      assert data.offers |> length() > 0

      # Check if parsed result has expected shape
      assert data.offers |> Enum.at(0) == %Offer{
               segment_ids: ["BA3292"],
               provider: "ba",
               price: 132.38,
               offer_id: "OFFER1",
               currency: "EUR"
             }
    end

    use_cassette "air france client" do
      data = CheapFlights.Integrations.AirFrance.load_data()
      assert data.offers |> length() > 0

      # Check if parsed result has expected shape
      assert data.offers |> Enum.at(0) == %Offer{
               segment_ids: ["SEG1", "SEG2"],
               provider: "ba",
               price: 199.29,
               offer_id: "e935785a-84a1-4b1a-b578-5a84a16b0001",
               currency: "EUR"
             }
    end
  end
end
