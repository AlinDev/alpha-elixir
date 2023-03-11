defmodule Devnet.CompareTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.Test.{Alice, Bob}
  alias Xprover.{AccountState, Token, TrParse, Balance}

  use ExUnit.Case

  test "compare current state with calculate history" do
    devnet = Network.get(:devnet)

    address = "erd12y3rjn6qw2zzrjlkz8uzxgspsc67y0uxajh3qu9xlzyqj06hhvpssath9m"

    {:ok, current} = AccountState.get_current(address, devnet)

    IO.inspect(current)

    {:ok, calculate} = AccountState.get_from_transaction_history(address, devnet)

    IO.inspect(calculate)

    # assert current.tokens = calculate.tokens
  end
end
