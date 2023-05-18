defmodule CheapFlights.Api.Helpers do
  @moduledoc false
  alias CheapFlights.Schemas.Offer

  def validate_params(params) do
    if not Map.has_key?(params, "origin") or not Map.has_key?(params, "destination") do
      {:error, "origin and destination query parameters must be specified"}
    else
      origin = Map.get(params, "origin")
      destination = Map.get(params, "destination")

      case parse_date(Map.get(params, "departureDate")) do
        {:error, _} = error -> error
        nil -> {origin, destination, nil}
        date_string -> {origin, destination, date_string}
      end
    end
  end

  def prepare_response(nil) do
    {
      404,
      Jason.encode!(%{error: "No flights found"})
    }
  end

  def prepare_response(%Offer{} = offer) do
    {
      200,
      Jason.encode!(%{
        data: %{
          cheapestOffer: %{
            amount: offer.price,
            airline: offer.provider
          }
        }
      })
    }
  end

  defp parse_date(
         <<year::binary-size(4), _d::binary-size(1), month::binary-size(2), _d2::binary-size(1),
           day::binary-size(2), _rest::binary>>
       ) do
    Enum.join([year, month, day], "-")
  end

  defp parse_date(nil), do: nil
  defp parse_date(""), do: nil
  defp parse_date(_), do: {:error, "Invalid date format"}
end
