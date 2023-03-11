defmodule Devnet.AccountV1EgldTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.AccountState
  alias Xprover.Test.{Alice, Bob}

  use ExUnit.Case

  @tag timeout: :infinity
  test "transfer 1 EGDL from Alice to AccountV1" do
    devnet = Network.get(:devnet)

    faucet = Faucet.get_account!()

    #
    {:ok, tr0} =
      Transaction.transaction(faucet, Alice.address(), 1_100_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr0)

    # prepare, sign and send transaction
    account_v1 = Account.generate_random()

    {:ok, tr1} =
      Transaction.transaction(Alice.account(), account_v1.address, 1_000_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr1)

    {:ok, account_v1_state} =
      AccountState.get_current(
        account_v1.address,
        devnet,
        version: 1,
        tx_hash: tr1["hash"]
      )

    account_v1_history = %{
      network: :devnet,
      address: account_v1.address,
      versions: [account_v1_state]
    }

    IO.inspect(account_v1_history)

    TestData.put_data(
      :devnet,
      :account_history,
      "#{account_v1.address}.json",
      account_v1_history
    )
  end
end
