defmodule ApiMobileWeb.Plug.ApiVersion do
  @moduledoc "API version validation plug"

  import Plug.Conn

  alias Plug.Conn

  @header "accept"
  @versions Application.get_env(:mime, :types)

  @error_no_header "Accept header required"
  @error_malformed_header "Malformed Accept header format"

  # Public

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t() | no_return
  def call(conn, _opts) do
    with {:ok, header} <- validate_required_header(conn),
         {:ok, version} <- validate_format(header) do
      assign(conn, :version, version)
    else
      {:error, err} -> no_header_error(conn, err)
    end
  end

  # Private

  @spec validate_required_header(Plug.Conn.t()) :: {:ok, binary} | {:error, binary}
  defp validate_required_header(conn) do
    case Conn.get_req_header(conn, @header) do
      [header] -> {:ok, header}
      _ -> {:error, @error_no_header}
    end
  end

  @spec validate_format(binary) :: {:ok, binary} | {:error, binary}
  defp validate_format(header) do
    case Map.fetch(@versions, header) do
      {:ok, [version]} -> {:ok, version}
      _ -> {:error, @error_malformed_header}
    end
  end

  @spec no_header_error(Plug.Conn.t(), binary) :: Plug.Conn.t() | no_return
  defp no_header_error(conn, err) do
    conn
    |> send_resp(:bad_request, err)
    |> halt()
  end
end
