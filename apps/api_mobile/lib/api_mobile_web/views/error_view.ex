defmodule ApiMobileWeb.ErrorView do
  @moduledoc "Error render module."

  use ApiMobileWeb, :view

  # Public

  @doc "Status code 500 response"
  def render("500.json", _assigns), do: %{errors: %{detail: "Internal Server Error"}}

  @doc "Status code fallback response"
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
