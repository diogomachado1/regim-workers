defmodule Entity.Product do
  def create(data, token ) do
    HTTPoison.post!(
        "http://localhost:3333/v1/pvt/products",
        Poison.encode!(data),
        [{
          "Content-Type", "application/json",
        },{
          "Authorization", "Bearer #{token}",
        }]
      )
  end

  def verifyChange(oldValue, newValue) do
    Enum.reduce(newValue, false,
      fn ({key, value}, acc) ->
        if value != oldValue[key], do: true, else: acc
      end
    )
  end

  def update(id, data, token ) do
    HTTPoison.put!(
        "http://localhost:3333/v1/pvt/products/#{id}",
        Poison.encode!(data),
        [{
          "Content-Type", "application/json",
        },{
          "Authorization", "Bearer #{token}",
        }]
      )
  end

  def get(id, token ) do
    HTTPoison.get!(
        "http://localhost:3333/v1/pvt/products/#{id}",
        [{
          "Content-Type", "application/json",
        },{
          "Authorization", "Bearer #{token}",
        }]
      )
  end
end
