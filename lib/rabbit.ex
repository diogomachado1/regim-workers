defmodule Rabbit do
  def openConnection do
    options = [host: "localhost", port: 5672, virtual_host: "/", username: "guest", password: "guest"]
    {:ok, connection} = AMQP.Connection.open(options)
    connection
  end

  def getChannel(connection) do
    {:ok, channel} = AMQP.Channel.open(connection)
    channel
  end

  def close(connection) do
    AMQP.Connection.close(connection)
  end
  def getQueue(queueName) do
    connection = openConnection()
    channel = getChannel(connection)
    AMQP.Queue.declare(channel, queueName)
    close(connection)
  end

  def sendMessage(channel, queueName, message) do
    AMQP.Basic.publish(channel, "", queueName, message)
  end

  def sendMultMessage(number) do
    connection = openConnection()
    channel = getChannel(connection)
    for n <- 1..number do
      jsonMessage =  %{test: n} |> Poison.encode!
      AMQP.Basic.publish(channel, "", "test", jsonMessage)
    end
    close(connection)
  end
end
