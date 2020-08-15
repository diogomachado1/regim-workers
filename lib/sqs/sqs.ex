defmodule Sqs.Sqs do
  def getQueue(queueName) do
    case ExAws.SQS.get_queue_url(queueName)|>ExAws.request() do
      {:ok, response} -> response.body.queue_url
      {:error, {:http_error, 400, _awsReponse}} ->
        case  ExAws.SQS.create_queue(queueName)|>ExAws.request() do
          {:ok, response} -> response.body.queue_url
        end
    end
  end

  def sendMessage(queueName, message) do
    jsonMessage = message |> Poison.encode!
    queueName |> getQueue
    ExAws.SQS.send_message(queueName |> getQueue, jsonMessage) |>ExAws.request()
    # |>
    #Sqs.Sqs.sendMessage("test.fifo",%{test: 23})
  end

  def sendMultMessage(number) do
    for n <- 1..number do
      sendMessage("test.fifo", %{test: n})
    end
  end
end
