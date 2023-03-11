defmodule Devnet.TransactionsTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.Test.{Alice, Bob}
  alias Xprover.{AccountState, Token, TrParse, Balance}

  use ExUnit.Case

  #
  # mix test test/devnet/transactions_test.exs
  #
  #
  # @tag :skip
  test "get transactions list for one account" do
    devnet = Network.get(:devnet)

    address = "erd12y3rjn6qw2zzrjlkz8uzxgspsc67y0uxajh3qu9xlzyqj06hhvpssath9m"

    {:ok, transactions} = REST.get_address_transactions(devnet, address)

    transactions
    |> Enum.map(fn tr ->
      {:ok, tr_wr} = REST.get_transaction(devnet, tr["hash"], withResults: true)
      tr_wr
    end)

    IO.inspect(transactions)

    IO.puts("------------------------")
    # parsed_transactions =
    #  transactions
    #  |> Enum.map(fn tr ->
    #    TrParse.parse(address, tr)
    #  end)

    # IO.inspect(parsed_transactions)

    calculate_tokens = Balance.calculate_tokens(address, transactions)
    IO.inspect(calculate_tokens)
  end
end
