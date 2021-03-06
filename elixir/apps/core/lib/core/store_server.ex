defmodule Core.StoreServer do
  @moduledoc false

  require Logger

  alias Core.Net

  use GenServer, restart: :permanent, shutdown: 10_000

  @max_messages 1000

  # Public

  def start_link(args) do 
    net_info()
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def pop(params \\ nil), do: GenServer.multi_call(__MODULE__, {:read, params})

  def pop_long(params \\ nil), do: GenServer.multi_call(__MODULE__, {:read_long, params})

  def push(value), do: GenServer.abcast(__MODULE__, {:write, value})

  # Callbacks

  @impl true
  def init(params) do
    {:ok, nil, {:continue, params}}
  end

  @impl true
  def handle_continue(_, _params) do
    start_pobox()

    {:noreply, %{value: "default value"}}
  end

  @impl true
  def handle_call({:read, _params}, _, state) do
    net_info()

    %{value: value} = state
    {:reply, value, state}
  end
  def handle_call({:read_long, params}, from, state) do
    net_info()

    Process.send(__MODULE__, {:read_long, from, params}, [:noconnect, :nosuspend])

    {:noreply, state}
  end

  @impl true
  def handle_cast({:write, value}, state) do
    net_info()

    new_state = put_in(state[:value], value)
    {:noreply, new_state}
  end

  @impl true
  def handle_info({:read_long, from, _params}, state) do
    :timer.sleep(5_000)
    GenServer.reply(from, state)

    {:noreply, state}
  end

  # Private

  defp net_info, do: Net.info |> Kernel.inspect |> Logger.debug

  defp start_pobox, do: {:ok, _} = :pobox.start_link(__MODULE__, @max_messages, :stack)
end