defmodule Gherkin.Pickle.Compiler do
  alias Gherkin.{GherkinDocument, Location, Pickle}

  @typep background_step :: %{arguments: [todo], locations: [Location.t()], text: String.t()}
  @typep foo :: %{background_steps: [background_step], pickles: [Pickle.t()]}
  @typep scenario_definition :: %{required(:type) => atom, optional(:steps) => [step_definition]}
  @typep step_definition :: %{argument: todo, text: String.t()}

  @typep todo :: any

  @spec compile(GherkinDocument.t()) :: [Pickle.t()]
  def compile(%GherkinDocument{feature: nil}), do: []

  def compile(%GherkinDocument{feature: %{children: children, language: language, tags: tags}}) do
    %{pickles: pickles} =
      Enum.reduce(children, %{background_steps: [], pickles: []}, fn
        %{type: :Background} = scenario_definition, foo ->
          compile_background(scenario_definition, foo)

        %{type: :Scenario} = scenario_definition, foo ->
          compile_scenario(scenario_definition, language, tags, foo)

        scenario_definition, foo ->
          compile_scenario_outline(scenario_definition, language, tags, foo)
      end)

    pickles
  end

  @spec compile_background(scenario_definition, foo) :: foo
  defp compile_background(scenario_definition, %{pickles: pickles}),
    do: %{background_steps: pickle_steps(scenario_definition), pickles: pickles}

  @spec pickle_steps(scenario_definition) :: [background_step]
  defp pickle_steps(%{steps: steps}) do
    for s <- steps,
        do: %{
          arguments: create_pickle_arguments(s.argument, [], []),
          locations: [pickle_step_location(s)],
          text: s.text
        }
  end

  @spec create_pickle_arguments(todo, [todo], [todo]) :: [todo]
  defp create_pickle_arguments(argument, variable_cells, value_cells), do: :TODO

  @spec pickle_step_location(step_definition) :: Location.t()
  defp pickle_step_location(step_definition), do: :TODO

  @spec compile_scenario(scenario_definition, todo, todo, foo) :: foo
  defp compile_scenario(scenario_definition, language, tags, foo), do: :TODO

  @spec compile_scenario_outline(scenario_definition, todo, todo, foo) :: foo
  defp compile_scenario_outline(scenario_definition, language, tags, foo), do: :TODO
end
