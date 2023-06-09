defmodule Xprover.AccountState do
  alias Xprover.{AccountState, Token, Balance}
  alias Elrondex.{Network, REST}

  defstruct nonce: 0,
            version: 0,
            balance: 0,
            tx_hash: nil,
            tokens: []

  def get_address_transactions(address, %Network{} = network) do
    # TODO
    REST.get_address_transactions(network, address)
  end

  def get_from_transaction_history(address, %Network{} = network, _opts \\ []) do
    with {:ok, transactions} <- REST.get_address_transactions(network, address),
         {:ok, calculate_tokens} <- Balance.calculate_tokens(address, transactions) do
      last_tokens =
        case List.last(calculate_tokens) do
          nil -> []
          last -> last["tokens"]
        end

      {:ok,
       %AccountState{
         tokens: last_tokens
       }}
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Return current account version.
  """
  def get_current(address, %Network{} = network, opts \\ []) do
    with {:ok, acc} <- REST.get_address(network, address),
         {:ok, tokens} <- get_tokens(address, network, acc) do
      {:ok,
       %AccountState{
         nonce: acc["nonce"],
         version: Keyword.get(opts, :version),
         balance: acc["balance"],
         tx_hash: Keyword.get(opts, :tx_hash),
         tokens: tokens
       }}
    else
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Return current account tokens list.
  List contain EGLD as first token.
  """
  def get_tokens(address, %Network{} = network, acc \\ nil) do
    with {:ok, acc} <- load_account(acc, address, network),
         {:ok, esdt_map} <- REST.get_address_esdt(network, address),
         {:ok, esdt_tokens} <- parse_tokens(esdt_map, []) do
      native = %Token{identifier: "EGLD", name: "Native EGLD token", balance: acc["balance"]}
      {:ok, [native | esdt_tokens]}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp load_account(nil, address, network) do
    REST.get_address(network, address)
  end

  defp load_account(acc, _network, _address) when is_map(acc) do
    {:ok, acc}
  end

  defp parse_tokens([], acc_tokens) when is_list(acc_tokens) do
    {:ok, acc_tokens}
  end

  defp parse_tokens(esdt_map, acc_tokens) when is_map(esdt_map) do
    # IO.inspect(esdt_map)

    esdt_only =
      esdt_map
      |> Enum.filter(fn {k, _v} -> length(String.split(k, "-")) == 2 end)
      |> Enum.map(fn {_k, v} -> v end)
      |> Enum.sort(fn {k1, _v1}, {k2, _v2} -> k1 < k2 end)

    # IO.inspect(esdt_only)

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
    account_state |> Map.take([:nonce, :version, :balance, :tx_hash, :tokens])
  end
end

defimpl Jason.Encoder, for: Xprover.AccountState do
  def encode(value, opts) do
    Jason.Encode.map(Xprover.AccountState.to_json(value), opts)
  end
end
