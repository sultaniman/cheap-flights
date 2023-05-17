defmodule CheapFlights.Schemas.Offer do
  @moduledoc false
  use TypedStruct

  typedstruct do
    @typedoc "Container for offers"
    field :currency, String.t(), enforce: true
    field :offer_id, String.t(), enforce: true
    field :price, float(), enforce: true
    field :provider, String.t(), enforce: true
    field :segment_ids, [String.t()], enforce: true
  end
end
