defmodule Xprover.AccountState do
  alias Xprover.AccountState

  defstruct nonce: 0,
            version: 0,
            balance: 0,
            tx_hash: nil

  def to_json(%AccountState{balance: balance} = account_state) when is_integer(balance) do
    %{account_state | balance: "#{balance}"}
    |> to_json()
  end

  def to_json(%AccountState{} = account_state) do
    account_state |> Map.take([:nonce, :version, :balance, :tx_hash])
  end
end

defimpl Jason.Encoder, for: Xprover.AccountState do
  def encode(value, opts) do
    Jason.Encode.map(Xprover.AccountState.to_json(value), opts)
  end
end
