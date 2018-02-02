defmodule Gherkin.Location do
  @opaque t :: %__MODULE__{column: non_neg_integer, line: non_neg_integer}

  defstruct [:column, :line]

  @spec new(non_neg_integer, non_neg_integer) :: t
  def new(line, column)
      when is_integer(line) and line >= 0 and is_integer(column) and column >= 0,
      do: %__MODULE__{column: column, line: line}

  @spec put_column(t, non_neg_integer) :: t
  def put_column(%__MODULE__{line: line}, column)
      when is_integer(column) and column > 0,
      do: %__MODULE__{column: column, line: line}
end
