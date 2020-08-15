defmodule MyBroadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "test",
          qos: [
            prefetch_count: 50,
          ],
          connection: [
            host: "localhost",
            username: "guest",
            password: "guest"
          ]
        },
        concurrency: 1,
      ],
      processors: [
        default: [
          concurrency: 100,
        ]
      ],
      batchers: [
        default: [
          batch_size: 30,
          concurrency: 80,
          batch_timeout: 2000
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) do
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch of finished jobs from processors, sending ACKs to SQS as a batch.")
    messages
  end

end
