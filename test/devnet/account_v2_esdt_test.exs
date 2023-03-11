defmodule Devnet.AccountV2EsdtTest do
  alias Elrondex.{ESDT, Network, Faucet, Transaction, REST, Account}
  alias Xprover.AccountState
  alias Xprover.Test.{Alice, Bob}

  use ExUnit.Case

  @tag timeout: :infinity
  test "transfer 2 XPROVER tokens from Alice to AccountV2 in 2 transactions" do
    devnet = Network.get(:devnet)

    faucet = Faucet.get_account!()

    identifier = Keyword.get(Application.get_env(:elrondex, Elrondex.Faucet), :esdt_token)
    esdt = %ESDT{identifier: identifier}

    #
    {:ok, tr0} =
      ESDT.transfer(faucet, Alice.address(), esdt, 2_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr0)

    # prepare, sign and send transaction
    account_v2 = Account.generate_random()

    {:ok, tr1} =
      ESDT.transfer(Alice.account(), account_v2.address, esdt, 1_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr1)

    {:ok, account_v2_state1} =
      AccountState.get_current(
        account_v2.address,
        devnet,
        version: 1,
        tx_hash: tr1["hash"]
      )

    {:ok, tr2} =
      ESDT.transfer(Alice.account(), account_v2.address, esdt, 1_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr2)

    {:ok, account_v2_state2} =
      AccountState.get_current(
        account_v2.address,
        devnet,
        version: 2,
        tx_hash: tr2["hash"]
      )

    account_v2_history = %{
      network: :devnet,
      address: account_v2.address,
      versions: [account_v2_state2, account_v2_state1]
    }

    IO.inspect(account_v2_history)

    TestData.put_data(
      :devnet,
      :account_history,
      "#{account_v2.address}.json",
      account_v2_history
    )
  end
end
