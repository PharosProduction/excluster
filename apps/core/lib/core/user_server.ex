defmodule Core.UserServer do
  @moduledoc false

  alias Core.Net

  require Logger

  @hibernate 60_000

  @behaviour :gen_statem

  # Public

  def child_spec([{:id, id} | _] = args) do
    start = {__MODULE__, :start_link, [args]}
    %{id: id, start: start, restart: :transient, type: :worker}
  end

  def start_link([{:id, id} | _params] = args) do 
    net_info()

    opts = [
      name: via(id),
      hibernate_after: @hibernate
    ]
    with {:ok, pid} <- :gen_statem.start_link(__MODULE__, args, opts) do
      :sys.statistics(pid, true)
      :sys.trace(pid, true)

      {:ok, pid}
    else
      other -> other
    end
  end

  def state(id) do
    [pid | _] = :gproc.lookup_pids(topic(id))
    :gen_statem.call(pid, :get_state)
  end

  def authenticated(id, token \\ "123qweasdzxc") do
    [pid | _] = :gproc.lookup_pids(topic(id))
    :gen_statem.cast(pid, {:authenticated, %{token: token}})
  end

  def stop(id) do
    [pid | _] = :gproc.lookup_pids(topic(id))
    :gen_statem.stop(pid)
  end

  # Callbacks

  @impl true
  def init([{:id, id} | _params] = args) do
    :gproc.reg(topic(id))

    actions = [{:timeout, 1_000 * 60 * 10, :make_outdated}]
    data = %{
      first_name: "John",
      last_name: "Doe",
      token: nil
    }
    {:ok, :unregistered, {id, data}, actions}
  end

  @impl true
  def handle_event({:call, from}, :get_state, state, {id, data}) do
    actions = [{:reply, from, {state, id, data}}]

    {:keep_state, {id, data}, actions}
  end
  def handle_event(:cast, {:authenticated, %{token: token}}, state, {id, data}) do
    new_data = put_in(data[:token], token)

    {:next_state, :authenticated, {id, new_data}}
  end
  def handle_event(:timeout, :make_outdated, state, data) do
    {:stop, :normal, data}
  end

  @impl true
  def callback_mode, do: :handle_event_function

  # Private
 
  defp via(id), do: {:via, :gproc, topic(id)}

  defp topic(id), do: {:p, :g, {:user_server, id}}

  defp net_info, do: Net.info |> Kernel.inspect |> Logger.debug
end