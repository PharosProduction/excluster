defmodule ApiMobileWeb.ErrorHelpers do
  @moduledoc "Conveniences for translating and building error messages module."

  @doc "Translates an error message using gettext."
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(ApiMobileWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(ApiMobileWeb.Gettext, "errors", msg, opts)
    end
  end
end
