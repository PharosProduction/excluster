defmodule Core.OtpServer do
  @moduledoc false

  alias Core.Net

  require Logger

  @hibernate 60_000

  @behaviour :gen_statem

  # Public

  def child_spec([{:id, id} | _] = args) do
    %{
      id: id, 
      start: {__MODULE__, :start_link, [args]}, 
      restart: :transient, 
      type: :worker
    }
  end

  def start_link([{:id, id} | _params] = args) do 
    net_info()

    opts = [
      name: via(id),
      hibernate_after: @hibernate
    ]
    with {:ok, pid} <- :gen_statem.start_link(__MODULE__, args, opts) do
      :sys.statistics(pid, true)
      # :sys.trace(pid, true)

      {:ok, pid}
    else
      other -> other
    end
  end

  def get_state(id) do
    net_info()

    with [pid | _] <- :gproc.lookup_pids(topic(id)) do
      :gen_statem.call(pid, :get_state)
    else
      [] -> {:error, :not_found}
    end
  end

  def request_code(id) do
    net_info()

    with [pid | _] <- :gproc.lookup_pids(topic(id)) do
      :gen_statem.call(pid, :request_code)
    else
      [] -> {:error, :not_found}
    end
  end

  def authorize_code(id) do
    net_info()

    with [pid | _] <- :gproc.lookup_pids(topic(id)) do
      :gen_statem.call(pid, :authorize_code)
    else
      [] -> {:error, :not_found}
    end
  end

  def stop(id) do
    net_info()

    with [pid | _] <- :gproc.lookup_pids(topic(id)) do
      :gen_statem.stop(pid)
    else
      [] -> {:error, :not_found}
    end
  end

  # Callbacks

  @impl true
  def init([{:id, id} | _params]) do
    :gproc.reg(topic(id))

    actions = [{:timeout, 1_000 * 5, :expired}]
    {:ok, :ready, id, actions}
  end

  def ready({:call, from}, :get_state, _), do: {:keep_state_and_data, {:reply, from, :ready}}
  def ready({:call, from}, :request_code, data) do
    {:next_state, :code_requested, data, {:reply, from, "1435"}}
  end
  def ready(:timeout, :expired, data) do
    IO.puts "TIMEOUT: #{inspect state}   #{inspect data}"
  end
  def ready({:call, from}, _, _), do: {:keep_state_and_data, {:reply, from, :not_allowed}}

  def code_requested({:call, from}, :get_state, _), do: {:keep_state_and_data, {:reply, from, :code_requested}}
  def code_requested({:call, from}, :authorize_code, data) do
    {:next_state, :code_authorized, data, {:reply, from, :ok}}
  end
  def code_requested({:call, from}, _, _), do: {:keep_state_and_data, {:reply, from, :not_allowed}}

  def code_authorized({:call, from}, :get_state, _), do: {:keep_state_and_data, {:reply, from, :code_authorized}}
  def code_authorized({:call, from}, _, _), do: {:keep_state_and_data, {:reply, from, :not_allowed}}

  @impl true
  def callback_mode, do: :state_functions

  @impl true
  def terminate(_reason, _state, _data), do: :nothing

  # Private
 
  defp via(id), do: {:via, :gproc, topic(id)}

  defp topic(id), do: {:p, :g, {:user_server, id}}

  defp net_info, do: Net.info |> Kernel.inspect |> Logger.debug
end