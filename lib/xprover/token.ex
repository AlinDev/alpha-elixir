defmodule Xprover.Token do
  alias Xprover.Token

  defstruct identifier: nil,
            name: nil,
            balance: 0

  # convert balance value to string
  def to_json(%Token{balance: balance} = token) when is_integer(balance) do
    %{token | balance: "#{balance}"}
    |> to_json()
  end

  # load token name (from cache)
  def to_json(%Token{name: nil} = token) do
    %{token | name: "Name for #{token.identifier}"}
    |> to_json()
  end

  # Export only
  def to_json(%Token{} = token) do
    token |> Map.take([:identifier, :name, :balance])
  end

  defimpl Jason.Encoder, for: Xprover.Token do
    def encode(value, opts) do
      Jason.Encode.map(Xprover.Token.to_json(value), opts)
    end
  end
end
