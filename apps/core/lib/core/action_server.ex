defmodule Core.ActionServer do
  use GenServer

  # Public

  def child_spec(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CHILD SPEC, #{inspect id}"
    IO.puts "--------------------------------------"
    %{
      id: id, 
      start: {__MODULE__, :start_link, [id]} 
    }
  end

  def start_link(id) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "START LINK, #{inspect id}"
    IO.puts "--------------------------------------"
    GenServer.start_link(__MODULE__, id, name: via_tuple(id))
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
    {:ok, {id, content}}
  end

  @impl true
  def handle_call({:contents}, _from, {_, content} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CALL, #{inspect state}"
    IO.puts "--------------------------------------"
    {:reply, content, state}
  end
  
  @impl true
  def handle_cast({:add, new_content}, {id, content} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "CAST, #{inspect new_content}"
    IO.puts "STATE #{inspect state}"
    IO.puts "--------------------------------------"
    {:noreply, {id, content ++ new_content}}
  end

  @impl true
  def terminate(reason, {id, content} = state) do
    IO.puts "NODE: #{inspect hostname()}"
    IO.puts "TERMINATE #{inspect reason} STATE #{inspect state}"
    IO.puts "--------------------------------------"

    Core.StateHandoff.handoff(id, content)
    :ok
  end
end