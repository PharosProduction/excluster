defmodule ApiMobileWeb.DemoView do
  @moduledoc false

  use ApiMobileWeb, :view

  # Public

  @doc "Demo Controller JSON response render."
  def render("v1.show.json", %{demo: demo}) do
    %{data: render_one(demo, ApiMobileWeb.DemoView, "demo.json")}
  end

  def render("demo.json", %{demo: demo}), do: %{demo: demo}
end
