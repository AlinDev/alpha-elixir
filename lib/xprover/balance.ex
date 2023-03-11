defmodule Xprover.Balance do
  alias Xprover.{Balance, TrParse}

  def add_balance_item({identifier, value}, tokens_balance)
      when is_binary(identifier) and is_integer(value) and is_map(tokens_balance) do
    new_value = Map.get(tokens_balance, identifier, 0) + value
    {:ok, Map.put(tokens_balance, identifier, new_value)}
  end

  def add_balance_item(move, tokens_balance) do
    IO.inspect({move, tokens_balance})
    {:error, :invalid_move}
  end

  def add_balance_list([], tokens_balance) do
    {:ok, tokens_balance}
  end

  def add_balance_list([{identifier, value} = item | tail], tokens_balance) do
    case add_balance_item(item, tokens_balance) do
      {:ok, new_tokens_balance} -> add_balance_list(tail, new_tokens_balance)
      {:error, error} -> {:error, error}
    end
  end

  def add_balance(move_map, tokens_balance) when is_map(move_map) do
    add_balance_list(Map.to_list(move_map), tokens_balance)
  end

  def add_transaction(address, tr, tokens_balance) do
    with {:ok, move_map} <- TrParse.parse(address, tr),
         {:ok, new_tokens_balance} <- add_balance(move_map, tokens_balance) do
      {:ok, new_tokens_balance}
    else
      {:error, error} -> {:error, error}
    end
  end

  def calculate_tokens(_address, [], calculate_transactions, _tokens_balance) do
    {:ok, Enum.reverse(calculate_transactions)}
  end

  def calculate_tokens(address, [tr | tr_tail], calculate_transactions, tokens_balance) do
    case add_transaction(address, tr, tokens_balance) do
      {:ok, new_tokens_balance} ->
        calculate_tokens(
          address,
          tr_tail,
          [Map.put(tr, "tokens", new_tokens_balance) | calculate_transactions],
          new_tokens_balance
        )

      {:error, error} ->
        {:error, error}
    end
  end
end
