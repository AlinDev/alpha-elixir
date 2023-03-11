defmodule Xprover.AccountState do
  alias Xprover.{AccountState, Token}
  alias Elrondex.{Network, REST}

  defstruct nonce: 0,
            version: 0,
            balance: 0,
            tx_hash: nil

  # EGLD

  @doc """
  Return current account tokens list.
  List contain EGLD as first token.
  """
  def get_tokens(address, %Network{} = network) do
    with {:ok, acc} <- REST.get_address(network, address),
         {:ok, esdt_map} <- REST.get_address_esdt(network, address),
         {:ok, esdt_tokens} <- parse_tokens(esdt_map, []) do
      native = %Token{identifier: "EGLD", name: "Native EGLD token", balance: acc["balance"]}
      [native | esdt_tokens]
    else
      {:error, error} -> {:error, error}
    end
  end

  defp parse_tokens([], acc_tokens) when is_list(acc_tokens) do
    {:ok, acc_tokens}
  end

  defp parse_tokens(esdt_map, acc_tokens) when is_map(esdt_map) do
    IO.inspect(esdt_map)

    esdt_only =
      esdt_map
      |> Enum.filter(fn {k, v} -> length(String.split(k, "-")) == 2 end)
      |> Enum.map(fn {k, v} -> v end)

    IO.inspect(esdt_only)

    parse_tokens(esdt_only, acc_tokens)
  end

  defp parse_tokens([h_token | t_tokens], acc_tokens) do
    case parse(h_token) do
      {:ok, token} -> parse_tokens(t_tokens, [token | acc_tokens])
      {:error, error} -> {:error, error}
    end
  end

  defp parse(%{"balance" => balance, "tokenIdentifier" => identifier}) do
    {:ok, %Token{identifier: identifier, balance: balance}}
  end

  defp parse(_acc_token) do
    {:error, :parse_error}
  end

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
