defmodule CheapFlights.Integrations do
  @moduledoc """
  Integrations handler implements logic to fetch
  and parse offers via all available integrations.
  """
  alias CheapFlights.Helpers

  @doc """
  Fetch and parse data from each integration
  Return value is a tuple with three elements,
  where

    1. List of offers,
    2. List of flight segments,
    3. Mapping `segment_id => [segment...]`

  It will looks something like

  ```
  {
    [
      %CheapFlights.Schemas.Offer{
        segment_ids: ["BA3292"],
        provider: "ba",
        price: 132.38,
        offer_id: "OFFER1",
        currency: "EUR"
      }
    ],
    [
      %CheapFlights.Schemas.FlightSegment{
        departure_date: "2021-09-28",
        segment_id: "BA3292",
        destination: "LCY",
        origin: "MUC"
      }
    ],
    %{
      "BA0947" => [
        %CheapFlights.Schemas.FlightSegment{
          departure_date: "2021-09-28",
          segment_id: "BA0947",
          destination: "LHR",
          origin: "MUC"
        }
      ]
    }
  }
  ```

  For each dataset we would like to

    1. Extract segments from dataset,
    2. Group by `segment_id` key and build mapping `segment_id => [segment...]`

  Later this will enable us to make filtering and lookup available offers
  """
  @spec load_data :: {list, list, map}
  def load_data do
    datasets =
      Application.get_env(:cheap_flights, :integrations)
      |> Enum.map(&Helpers.fetch_async/1)
      |> Task.await_many()

    segments =
      datasets
      |> Enum.map(&Map.get(&1, :flight_segments))
      |> List.flatten()

    segment_mapping =
      segments
      |> Enum.group_by(&Map.get(&1, :segment_id))

    offers =
      datasets
      |> Enum.map(&Map.get(&1, :offers))
      |> List.flatten()

    {
      offers,
      segments,
      segment_mapping
    }
  end
end
