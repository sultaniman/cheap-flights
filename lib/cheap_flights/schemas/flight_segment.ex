defmodule CheapFlights.Schemas.FlightSegment do
  @moduledoc false
  use TypedStruct

  typedstruct do
    @typedoc "Container for flight segments"

    # we assume that all fields are always present
    field :origin, String.t(), enforce: true
    field :destination, String.t(), enforce: true
    field :segment_id, String.t(), enforce: true
    field :departure_date, String.t(), enforce: true
  end
end
