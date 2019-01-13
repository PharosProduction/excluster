defmodule Core.ActionServer do
  use GenServer

  require Logger

  # Public

  def child_spec(id) do
    %{
      id: id,
      start: {__MODULE__, :start_link, [id]},
      shutdown: 10_000,
      restart: :permanent
    }
  end

  def start_link(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "START LINK, #{inspect id}"
    IO.puts "--------------------------------------"
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
  end

  def how_many?(name \\ __MODULE__) do
    GenServer.call(via_tuple(name), :how_many?)
  end

  def add(id, content) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "ADD, #{inspect id}, #{inspect content}"
    IO.puts "--------------------------------------"
    GenServer.cast(via_tuple(id), {:add, content})
  end

  def contents(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CONTENTS, #{inspect id}"
    IO.puts "--------------------------------------"
    GenServer.call(via_tuple(id), {:contents})
  end
  
  # Private

  defp via_tuple(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "VIA TUPLE, #{inspect id}"
    IO.puts "--------------------------------------"
    {:via, Horde.Registry, {Core.Registry, id}}
  end

  defp get_global_counter() do
    case Horde.Registry.meta(Core.Registry, "count") do
      {:ok, count} ->
        count

      :error ->
        put_global_counter(0)
        get_global_counter()
    end
  end

  defp put_global_counter(counter_value) do
    :ok = Horde.Registry.put_meta(Core.Registry, "count", counter_value)
    counter_value
  end

  def hostname do
    name = :inet.gethostname()
    |> Kernel.elem(1)
    |> List.to_string()

    {:ok, name}
  end

  # Callbacks

  @impl true
  def init(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "VIA TUPLE, #{inspect id}"
    Process.flag(:trap_exit, true)
    content = Core.StateHandoff.pickup(id)
    IO.puts "HANDOFF: #{inspect content}"
    IO.puts "--------------------------------------"

    send(self(), :say_hello)

    {:ok, {id, content, get_global_counter()}}
  end

  @impl true
  def handle_call({:contents}, _from, {id, content, counter} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CALL, #{inspect state}"
    IO.puts "--------------------------------------"
    {:reply, content, state}
  end
  def handle_call(:how_many?, _from, {id, content, counter} = state) do
    {:reply, counter, state}
  end

  @impl true
  def handle_info(:say_hello, {id, content, counter} = state) do
    Logger.info("HELLO from node #{inspect(Node.self())}")
    Process.send_after(self(), :say_hello, 5000)

    {:noreply, {id, content, put_global_counter(counter + 1)}}
  end
  
  @impl true
  def handle_cast({:add, new_content}, {id, content, counter} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CAST, #{inspect new_content}"
    IO.puts "STATE #{inspect state}"
    IO.puts "--------------------------------------"
    {:noreply, {id, content ++ new_content, counter}}
  end

  @impl true
  def terminate(reason, {id, content, counter} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "TERMINATE #{inspect reason} STATE #{inspect state}"
    IO.puts "--------------------------------------"

    Core.StateHandoff.handoff(id, content)
    :ok
  end
end