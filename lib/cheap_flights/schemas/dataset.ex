defmodule CheapFlights.Schemas.Dataset do
  @moduledoc false
  use TypedStruct
  alias CheapFlights.Schemas.{FlightSegment, Offer}

  typedstruct do
    @typedoc "Container struct which holds offers and flight segments"
    field :offers, [Offer.t()]
    field :flight_segments, [FlightSegment.t()]
  end
end
