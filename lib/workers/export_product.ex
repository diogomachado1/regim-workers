defmodule Worker.ExportProducts do
  use Broadway

  alias Broadway.Message


  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {
          BroadwayRabbitMQ.Producer,
          queue: "export-product",
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
    xlsx = body["userId"]
    |> Repo.Product.getProductByUserId
    |> Enum.map(fn (%Repo.Product{id: id,name: name, measure: measure, amount: amount, price: price}) -> %{id: id,name: name, measure: measure, amount: amount, price: price} end)
    |> Export.Product.render
    #teste = NimbleCSV.define(NimbleCSV.Spreadsheet, [])
    #productsCsv = teste.dump_to_iodata(productsMap)
    token = Token.generate_and_sign!(%{"id"=> body["userId"]})
    response = HTTPoison.post(
      "http://localhost:3333/v1/pvt/files",
      {:multipart, [{"file", xlsx, {"form-data", [name: "file", filename: "Pasta1.xlsx"]}, ["Content-Type": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]}]},
      [
        "Authorization": "Bearer #{token}",
      ]
    )
    response |> IO.inspect
    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    messages |> Enum.map(fn e -> e.data end)
    messages
  end

end
