defmodule Pulsar.Consumer do
  use WebSockex

  # bin/pulsar standalone --advertised-address 127.0.0.1
  def start_link do
    url = "ws://127.0.0.1:8080/ws/v2/consumer/persistent/public/default/test-topic/shared"
    {:ok, pid} = WebSockex.start_link(url, __MODULE__, nil)
    IO.puts "CONSUMER: #{inspect pid}"
    {:ok, pid}
  end

  def terminate(reason, state) do
    IO.puts("WebSockex for remote debbugging on port #{state.port} terminating with reason: #{inspect reason}")
    exit(:normal)
  end

  def handle_connect(_conn, state) do
    IO.puts "CONSUMER: Connected!"
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    %{
      "messageId" => messageId,
      "payload" => payload,
      "properties" => props, 
      "publishTime" => ctx
    } = Jason.decode!(msg)
    msg = Base.decode64(payload)

    IO.puts "CONSUMER MSG: #{inspect msg}"
    IO.puts "CONSUMER PROPS: #{inspect props}"
    IO.puts "CONSUMER CTX: #{inspect ctx}"

    json = Jason.encode!(%{"messageId" => messageId})
    IO.puts "SENDING ACK: #{inspect json}"

    {:reply, {:text, json}, state}
  end

  def handle_disconnect(%{reason: {:local, reason}}, state) do
    Logger.info("Local close with reason: #{inspect reason}")
    {:ok, state}
  end
  def handle_disconnect(disconnect_map, state) do
    super(disconnect_map, state)
  end
end