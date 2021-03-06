defmodule Worker.ImportProduct do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "import-product",
          qos: [
            prefetch_count: 50,
          ],
          connection: [
            host: "localhost",
            username: "guest",
            password: "guest"
          ],
        },
        concurrency: 20,
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
    body = Poison.decode!(data)
    token = Token.generate_and_sign!(%{"id"=> body["userId"]})
    if Map.has_key?(body["payload"], "id") do
      id = body["payload"]["id"]
      response = Entity.Product.get(id,token)
      response.status_code |> IO.puts
      cond do
        response.status_code === 404 ->
          Entity.Product.create(body["payload"],token)
          "#{id}, add" |> IO.puts
        response.status_code === 200 ->
          get_body = response.body |> Poison.decode!
          hasChange = Entity.Product.verifyChange(get_body, body["payload"])
          "#{id}, #{hasChange}, att" |> IO.puts
          if hasChange do
            Entity.Product.update(id, body["payload"],token)
          end
          response.status_code <= 500 -> IO.puts("Error")
      end
    else
      Entity.Product.create(body["payload"],token)
      "add" |> IO.puts
    end
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages |> Enum.map(fn e -> e.data end)
    messages
  end

end
