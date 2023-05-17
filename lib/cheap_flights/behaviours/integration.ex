defmodule CheapFlights.Behaviours.Integration do
  @moduledoc false
  alias CheapFlights.Schemas.Dataset

  @doc """
  Fetch and parse data from configured sources
  """
  @callback load_data() :: [Dataset.t()]
end
