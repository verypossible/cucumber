defmodule Gherkin.Location do
  @type t :: %__MODULE__{column: non_neg_integer, line: non_neg_integer}

  defstruct [:column, :line]
end
