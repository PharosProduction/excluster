defmodule Pulsar.Producer do
  use WebSockex

  # bin/pulsar standalone --advertised-address 127.0.0.1
  def start_link do
    url = "ws://127.0.0.1:8080/ws/v2/producer/persistent/public/default/test-topic"
    {:ok, pid} = WebSockex.start_link(url, __MODULE__, nil)
    IO.puts "STARTED: #{inspect pid}"

    json = Jason.encode!(%{
      "payload" => Base.encode64("hello there"), 
      "properties" => %{
        "key1" => "value1", 
        "key2" => "value2"
      }, 
      "context" => 1
    })
    IO.puts "SENDING: #{inspect json}"
    WebSockex.send_frame(pid, {:text, json})
    IO.puts "SENT"
  end

  def handle_connect(_conn, state) do
    IO.puts "Connected!"
    {:ok, state}
  end

  def handle_frame({:text, msg}, state) do
    IO.puts "FRAME: #{inspect msg}"

    {:ok, state}
  end
end