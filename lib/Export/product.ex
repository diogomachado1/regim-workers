defmodule Export.Product do
  alias Elixlsx.{Workbook, Sheet}
  @header [
      "id",
      "name",
      "measure",
      "amount",
      "price"
    ]
  def render(products) do
      report_generator(products)
      |> Elixlsx.write_to_memory("report.xlsx")
      |> elem(1)
      |> elem(1)
  end
  def report_generator(products) do
      rows = products |> Enum.map(&(row(&1)))
      %Workbook{sheets: [%Sheet{name: "Products", rows: [@header] ++ rows}]}
  end
  def row(product) do
      [
        product.id,
        product.name,
        product.measure,
        Decimal.to_float(product.amount),
        Decimal.to_float(product.price),
      ]
  end
end
