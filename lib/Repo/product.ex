defmodule Repo.Product do
  use Ecto.Schema


  require Ecto.Query
  schema "products" do
    field :name, :string
    field :measure, :string
    field :amount, :decimal
    field :price, :decimal
    field :user_id, :integer
  end

  def getProductByUserId(userId) do
    Repo.Product |> Ecto.Query.where(user_id: ^userId) |> ImportMassive.Repo.all
  end
end
