defmodule CheapFlightsApiHelpersTest do
  use ExUnit.Case, async: true
  alias CheapFlights.Api.Helpers

  test "date parsing works as expected for valid dates" do
    result =
      Helpers.validate_params(%{
        "origin" => "MUX",
        "destination" => "LUX",
        "departureDate" => "2023-12-21"
      })

    assert result == {"MUX", "LUX", "2023-12-21"}

    result =
      Helpers.validate_params(%{
        "origin" => "MUX",
        "destination" => "LUX",
        "departureDate" => "2023-12-21T11:11:11"
      })

    assert result == {"MUX", "LUX", "2023-12-21"}
  end

  test "date parsing works as expected for invalid or nil dates" do
    result =
      Helpers.validate_params(%{
        "origin" => "MUX",
        "destination" => "LUX",
        "departureDate" => "2023"
      })

    assert result == {:error, "Invalid date format"}

    result =
      Helpers.validate_params(%{"origin" => "MUX", "destination" => "LUX", "departureDate" => nil})

    assert result == {"MUX", "LUX", nil}

    result = Helpers.validate_params(%{"origin" => "MUX", "destination" => "LUX"})
    assert result == {"MUX", "LUX", nil}
  end
end
