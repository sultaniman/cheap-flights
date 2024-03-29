defmodule CheapFlightsApiTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  use Plug.Test

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/cassettes")
    :ok
  end

  @router_opts CheapFlights.Api.Router.init([])

  test "API is available" do
    use_cassette "british airways client" do
      conn = conn(:get, "/favicon.ico")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 200
    end
  end

  test "API matches HTTP 404 routes" do
    use_cassette "british airways client" do
      conn = conn(:get, "/mooouv")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 404
      assert conn.resp_body =~ "Oi bruv moo innit! Not fond!"
    end
  end

  test "API cheapest flight price lookup works" do
    use_cassette "air france client" do
      conn = conn(:get, "/findCheapestOffer/?origin=MUC&destination=ORY&departureDate=2021-09-26")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 200

      assert conn.resp_body ==
               Jason.encode!(%{
                 data: %{
                   cheapestOffer: %{
                     airline: "klm",
                     amount: 274.29
                   }
                 }
               })

      conn = conn(:get, "/findCheapestOffer/?origin=CDG&destination=LHR&departureDate=2021-09-26")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 200

      assert conn.resp_body ==
               Jason.encode!(%{
                 data: %{
                   cheapestOffer: %{
                     airline: "klm",
                     amount: 199.29
                   }
                 }
               })

      conn = conn(:get, "/findCheapestOffer/?origin=MUC&destination=CDG&departureDate=2021-09-26")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 200

      assert conn.resp_body ==
               Jason.encode!(%{
                 data: %{
                   cheapestOffer: %{
                     airline: "klm",
                     amount: 199.29
                   }
                 }
               })
    end
  end

  test "API cheapest flight price lookup returns HTTP 404 if no match found" do
    use_cassette "british airways client" do
      conn = conn(:get, "/findCheapestOffer/?origin=MUC&destination=LAX&departureDate=2100-09-28")
      conn = CheapFlights.Api.Router.call(conn, @router_opts)
      assert conn.status == 404
      assert conn.resp_body == Jason.encode!(%{error: "No flights found"})
    end
  end
end
