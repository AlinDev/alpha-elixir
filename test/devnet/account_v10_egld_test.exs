defmodule Devnet.AccountV10EgldTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.{AccountState, Token}
  alias Xprover.Test.{Alice, Bob}

  use ExUnit.Case

  def send_transaction(network, account, nonce, address, wait) do
    {:ok, pid} =
      Agent.start_link(fn ->
        Transaction.transaction(account, address, 100_000_000_000_000_000)
        |> Transaction.prepare(network, nonce)
        |> Transaction.sign()
        |> REST.post_transaction_send()
      end)

    case wait do
      true ->
        Agent.get(
          pid,
          fn {:ok, tr_hash} ->
            Transaction.wait({:ok, tr_hash}, network, withResults: true)
          end,
          :infinity
        )

      false ->
        Agent.get(pid, fn state -> state end)
    end
  end

  @tag timeout: :infinity
  test "transfer 1 EGDL from Alice to AccountV10 with 10 transactions" do
    devnet = Network.get(:devnet)

    faucet = Faucet.get_account!()

    #
    {:ok, tr0} =
      Transaction.transaction(faucet, Alice.address(), 1_200_000_000_000_000_000)
      |> Transaction.prepare(devnet)
      |> Transaction.sign()
      |> REST.post_transaction_send()
      |> Transaction.wait(devnet, withResults: true)

    IO.inspect(tr0)

    # prepare, sign and send transaction
    account_v10 = Account.generate_random()
    {:ok, nonce} = REST.get_address_nonce(devnet, Alice.address())

    versions =
      Enum.map([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], fn index ->
        wait = index == 9

        # Brodcast first 9 tr and wait to tr 10
        {ok, tx_or_hash} =
          send_transaction(devnet, Alice.account(), nonce + index, account_v10.address, wait)

        tx_hash =
          case wait do
            false ->
              tx_or_hash

            true ->
              tx_or_hash["hash"]
          end

        balance = 100_000_000_000_000_000 * (index + 1)

        %AccountState{
          nonce: 0,
          version: index + 1,
          balance: balance,
          tx_hash: tx_hash,
          tokens: [%Token{identifier: "EGLD", name: "Native EGLD token", balance: balance}]
        }
      end)
      |> Enum.reverse()

    IO.inspect(versions)

    account_v10_history = %{
      network: :devnet,
      address: account_v10.address,
      versions: versions
    }

    IO.inspect(account_v10_history)

    TestData.put_data(
      :devnet,
      :account_history,
      "#{account_v10.address}.json",
      account_v10_history
    )
  end
end
