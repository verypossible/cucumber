defmodule Gherkin.GherkinLine.Span do
  @type t :: %__MODULE__{column: pos_integer, text: String.t()}

  @enforce_keys [:column, :text]
  defstruct @enforce_keys
end
