defmodule CheapFlightsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/cassettes")
    :ok
  end

  test "clients work as expected" do
    use_cassette "british airways client" do
      assert CheapFlights.Integrations.BritishAirways.load_data() |> length() > 0
    end

    use_cassette "air france client" do
      assert CheapFlights.Integrations.AirFrance.load_data() |> length() > 0
    end
  end
end
