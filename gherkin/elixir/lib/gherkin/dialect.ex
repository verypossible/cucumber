defmodule Gherkin.Dialect do
  @type keywords :: [String.t(), ...]
  @type t :: pid

  @spec and_keywords(t) :: keywords
  def and_keywords(dialect), do: fetch(dialect, "and")

  @spec background_keywords(t) :: keywords
  def background_keywords(dialect), do: fetch(dialect, "background")

  @spec but_keywords(t) :: keywords
  def but_keywords(dialect), do: fetch(dialect, "but")

  @spec examples_keywords(t) :: keywords
  def examples_keywords(dialect), do: fetch(dialect, "examples")

  @spec feature_keywords(t) :: keywords
  def feature_keywords(dialect), do: fetch(dialect, "feature")

  @spec given_keywords(t) :: keywords
  def given_keywords(dialect), do: fetch(dialect, "given")

  @spec scenario_keywords(t) :: keywords
  def scenario_keywords(dialect), do: fetch(dialect, "scenario")

  @spec scenario_outline_keywords(t) :: keywords
  def scenario_outline_keywords(dialect), do: fetch(dialect, "scenarioOutline")

  @external_resource dialects_path =
                       :gherkin
                       |> :code.priv_dir()
                       |> Path.join("gherkin-languages.json")

  @spec start_link(String.t()) :: {:ok, pid} | {:error, :unknown_dialect | term}
  for {name, spec} <- dialects_path |> File.read!() |> Poison.decode!() do
    def start_link(name), do: Agent.start_link(fn -> spec end)
  end

  def start_link(_name), do: {:error, :unknown_dialect}

  @spec then_keywords(t) :: keywords
  def then_keywords(dialect), do: fetch(dialect, "then")

  @spec when_keywords(t) :: keywords
  def when_keywords(dialect), do: fetch(dialect, "when")

  @spec fetch(t, String.t()) :: keywords
  defp fetch(dialect, key), do: Agent.get(dialect, &Map.fetch!(key))
end
