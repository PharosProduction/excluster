defmodule ApiMobileWeb.ClusterView do
  @moduledoc false

  use ApiMobileWeb, :view

  # Public

  def render("v1.hostname.json", %{cluster: cluster}) do
    %{data: render_one(cluster, ApiMobileWeb.ClusterView, "hostname.json")}
  end

  def render("v1.nodes.json", %{cluster: cluster}) do
    %{data: %{nodes: render_many(cluster, ApiMobileWeb.ClusterView, "node.json")}}
  end

  def render("v1.ping.json", %{cluster: cluster}) do
    %{data: render_one(cluster, ApiMobileWeb.ClusterView, "ping.json")}
  end

  def render("v1.names.json", %{cluster: cluster}) do
    %{data: cluster}
  end

  def render("hostname.json", %{cluster: hostname}), do: %{hostname: hostname}

  def render("node.json", %{cluster: node}), do: %{node: node}

  def render("ping.json", %{cluster: ping}), do: %{ping: ping}
end
