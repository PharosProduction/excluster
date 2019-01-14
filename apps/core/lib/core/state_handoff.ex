defmodule Core.StateHandoff do
  use GenServer

  require Logger

  # Public

  def child_spec(opts \\ []) do
    start = {__MODULE__, :start_link, [opts]}
    %{id: __MODULE__, start: start}
  end

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  
  def join(node) do
    request = {:add_neighbours, {__MODULE__, node}}
    GenServer.call(__MODULE__, request)
  end

  def handoff(id, state) do
    request = {:handoff, id, state}
    GenServer.call(__MODULE__, request)
  end

  def pickup(id) do
    request = {:pickup, id}
    GenServer.call(__MODULE__, request)
  end

  # Callbacks

  @impl true
  def init(_) do
    args = [
      sync_interval: 5,
      ship_interval: 5,
      ship_debounce: 1
    ]
    DeltaCrdt.start_link(DeltaCrdt.AWLWWMap, args)
  end

  @impl true
  def handle_call({:add_neighbours, other_node}, _, crdt_pid) do
    other_crdt_pid = GenServer.call(other_node, {:fulfill_add_neighbours, crdt_pid})
    DeltaCrdt.add_neighbours(crdt_pid, [other_crdt_pid])

    {:reply, :ok, crdt_pid}
  end
  def handle_call({:fulfill_add_neighbours, other_crdt_pid}, _, crdt_pid) do
    DeltaCrdt.add_neighbours(crdt_pid, [other_crdt_pid])

    {:reply, crdt_pid, crdt_pid}
  end
  def handle_call({:handoff, id, state}, _, crdt_pid) do
    DeltaCrdt.mutate(crdt_pid, :add, [id, state])

    {:reply, :ok, crdt_pid}
  end
  def handle_call({:pickup, id}, _, crdt_pid) do
    state = crdt_pid
    |> DeltaCrdt.read()
    |> Map.get(id, [])
    DeltaCrdt.mutate(crdt_pid, :remove, [id])

    {:reply, state, crdt_pid}
  end
  def handle_call(request, from, state), do: super(request, from, state)
end