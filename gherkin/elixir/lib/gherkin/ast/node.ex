defmodule Gherkin.AST.Node do
  @type rule_type :: atom
  @type t :: pid

  @spec add_child(t, rule_type, term) :: :ok
  def add_child(ast_node, rule_type, child),
    do:
      Agent.update(ast_node, fn state ->
        Map.update!(state, :children, fn children ->
          Map.update(children, rule_type, [child], &List.insert_at(&1, -1, child))
        end)
      end)

  @spec get_children(t, rule_type) :: list
  def get_children(ast_node, rule_type),
    do: Agent.get(ast_node, &Map.get(&1.children, rule_type, []))

  @spec get_single(t, rule_type) :: term | nil
  def get_single(ast_node, rule_type),
    do:
      Agent.get(ast_node, fn %{children: children} ->
        if list = children[rule_type], do: hd(list)
      end)

  @spec rule_type(t) :: rule_type
  def rule_type(ast_node), do: Agent.get(ast_node, & &1.rule_type)

  @spec start_link(rule_type) :: {:ok, pid} | {:error, term}
  def start_link(rule_type),
    do: Agent.start_link(fn -> %{children: %{}, rule_type: rule_type} end)

  @spec stop(t) :: :ok
  def stop(ast_node), do: Agent.stop(ast_node)
end
