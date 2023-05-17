defmodule CheapFlightsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/cassettes")
    :ok
  end

  test "clients work as expected" do
    use_cassette "british airways client" do
      data = CheapFlights.Integrations.BritishAirways.load_data()
      assert data.offers |> length() > 0
    end

    use_cassette "air france client" do
      data = CheapFlights.Integrations.AirFrance.load_data()
      assert data.offers |> length() > 0
    end
  end
end
