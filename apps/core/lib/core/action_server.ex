defmodule Core.ActionServer do
  @moduledoc false

  use GenServer, shutdown: 10_000, restart: :permanent

  alias Core.Counters

  # Public

  def child_spec([{:id, id} | params] = args) do
    start = {__MODULE__, :start_link, [args]}
    %{id: id, start: start}
  end

  def start_link([{:id, id} | params] = args) do 
    GenServer.start_link(__MODULE__, args, name: via_tuple(id))
  end

  def read(id, params), do: GenServer.call(via_tuple(id), {:read, params})

  def write(id, value), do: GenServer.cast(via_tuple(id), {:write, value})

  # Callbacks

  @impl true
  def init([{:id, id} | params] = args) do
    Process.flag(:trap_exit, true)

    state = Core.StateHandoff.pickup(id)
    |> case do
      [] -> %{value: "some value"}
      restored -> restored
    end

    {:ok, {id, state}}
  end

  @impl true
  def handle_call({:read, params}, _from, {id, state}) do
    Counters.inc_counter(:read)

    %{value: value} = state
    {:reply, value, {id, state}}
  end
  def handle_call(request, from, state), do: super(request, from, state)

  @impl true
  def handle_cast({:write, value}, {id, state}) do
    Counters.inc_counter(:write)

    new_state = put_in(state[:value], value)
    {:noreply, {id, new_state}}
  end
  def handle_cast(request, state), do: super(request, state)

  @impl true
  def terminate(reason, {id, state}) do
    Core.StateHandoff.handoff(id, state)
    :ok
  end

  # Private

  defp via_tuple(id), do: {:via, Horde.Registry, {Core.Registry, id}}
end