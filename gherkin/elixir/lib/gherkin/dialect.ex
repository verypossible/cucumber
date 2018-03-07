defmodule Gherkin.Dialect do
  @type keywords :: [String.t(), ...]
  @type t :: %__MODULE__{
          and_keywords: keywords,
          background_keywords: keywords,
          but_keywords: keywords,
          examples_keywords: keywords,
          feature_keywords: keywords,
          given_keywords: keywords,
          scenario_keywords: keywords,
          scenario_outline_keywords: keywords,
          then_keywords: keywords,
          when_keywords: keywords
        }

  mapping = %{
    and_keywords: "and",
    background_keywords: "background",
    but_keywords: "but",
    examples_keywords: "examples",
    feature_keywords: "feature",
    given_keywords: "given",
    scenario_keywords: "scenario",
    scenario_outline_keywords: "scenarioOutline",
    then_keywords: "then",
    when_keywords: "when"
  }

  defstruct Map.keys(mapping)

  @external_resource dialects_path =
                       :gherkin
                       |> :code.priv_dir()
                       |> Path.join("gherkin-languages.json")

  @spec get(String.t()) :: t() | nil
  for {name, spec} <- dialects_path |> File.read!() |> Poison.decode!() do
    dialect =
      mapping
      |> Stream.map(fn {field, key} -> {field, Map.fetch!(spec, key)} end)
      |> Enum.into(%{})
      |> Map.put(:__struct__, __MODULE__)

    def get(unquote(name)), do: unquote(Macro.escape(dialect))
  end

  def get(name) when is_binary(name), do: nil
end
