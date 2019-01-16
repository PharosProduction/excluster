defmodule Core.UserServer do
  @moduledoc false

  alias Core.{
    Net
  }

  require Logger

  @shutdown 10_000
  @hibernate 60_000

  use GenServer, restart: :transient, shutdown: @shutdown

  # Public

  def child_spec([{:id, id} | _] = args) do
    start = {__MODULE__, :start_link, [args]}
    %{id: id, start: start}
  end

  def start_link([{:id, id} | _params] = args) do 
    net_info()

    opts = [
      name: id, 
      hibernate_after: @hibernate
    ]
    with {:ok, pid} <- GenServer.start_link(__MODULE__, args, opts) do
      :sys.statistics(pid, true)
      :sys.trace(pid, true)

      {:ok, pid}
    else
      other -> other
    end
  end

  # Callbacks

  @impl true
  def init([{:id, _id} | _params]) do
    {:ok, nil}
  end

  # Private

  defp net_info, do: Net.info |> Kernel.inspect |> Logger.debug
end