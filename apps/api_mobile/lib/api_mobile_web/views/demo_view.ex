defmodule ApiMobileWeb.DemoView do
  @moduledoc false

  use ApiMobileWeb, :view

  # Public

  @doc "Demo Controller JSON response render."
  def render("v1.demo.json", %{demo: demo}) do
    %{data: render_one(demo, ApiMobileWeb.DemoView, "demo.json")}
  end

  def render("v1.nodes.json", %{demo: demo}) do
    %{data: render_many(demo, ApiMobileWeb.DemoView, "node.json")}
  end

  def render("v1.ping.json", %{demo: demo}) do
    %{data: render_one(demo, ApiMobileWeb.DemoView, "ping.json")}
  end

  def render("v1.names.json", %{demo: demo}) do
    %{data: render_many(demo, ApiMobileWeb.DemoView, "name.json")}
  end

  def render("demo.json", %{demo: demo}), do: %{demo: demo}

  def render("node.json", %{demo: node}), do: %{node: node}

  def render("ping.json", %{demo: ping}), do: %{answer: ping}

  def render("name.json", %{demo: node}), do: %{name: elem(node, 0) |> List.to_string, port: elem(node, 1)}
end
