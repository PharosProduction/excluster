defmodule Core.ActionServer do
  @moduledoc false

  use GenServer, shutdown: 10_000, restart: :permanent

  alias Core.{Counters, StateHandoff}

  @registry Core.Registry

  # Public

  def child_spec([{:id, id} | _] = args) do
    start = {__MODULE__, :start_link, [args]}
    %{id: id, start: start}
  end

  def start_link([{:id, id} | _] = args) do 
    GenServer.start_link(__MODULE__, args, name: via_tuple(id))
  end

  def read(id, params), do: GenServer.call(via_tuple(id), {:read, params})

  def write(id, value), do: GenServer.cast(via_tuple(id), {:write, value})

  # Callbacks

  @impl true
  def init([{:id, id} | _params]) do
    Process.flag(:trap_exit, true)

    state = id
    |> StateHandoff.pickup
    |> case do
      [] -> %{value: "some value"}
      restored -> restored
    end

    {:ok, {id, state}}
  end

  @impl true
  def handle_call({:read, _params}, _, {id, state}) do
    Counters.inc_counter(:read)

    %{value: value} = state
    {:reply, value, {id, state}}
  end

  @impl true
  def handle_cast({:write, value}, {id, state}) do
    Counters.inc_counter(:write)

    new_state = put_in(state[:value], value)
    {:noreply, {id, new_state}}
  end

  @impl true
  def terminate(_reason, {id, state}) do
    StateHandoff.handoff(id, state)
    :ok
  end

  # Private

  defp via_tuple(id), do: {:via, Horde.Registry, {@registry, id}}
end