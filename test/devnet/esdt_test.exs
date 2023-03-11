defmodule Devnet.EsdtTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.Test.{Alice, Bob}
  alias Xprover.{AccountState, Token}

  use ExUnit.Case

  #
  # mix test test/devnet/esdt_test.exs
  #
  #
  @tag :skip
  test "get esdt list for one account" do
    devnet = Network.get(:devnet)

    address = "erd1c579aq6kjkhar6cyx8qm9k9wettxjcf3jncduwe0pllqx0rlczfskg3vk2"

    esdt = REST.get_address_esdt(devnet, address)

    IO.inspect(esdt)
  end

  @tag :skip
  test "test token encode" do
    token = %Token{identifier: "RIDE-6e4c49", balance: 100_000}
    json = Jason.encode!(token, pretty: true)
    IO.puts(json)
    #
    # {
    #   "balance": "100000",
    #   "identifier": "RIDE-6e4c49",
    #   "name": "Name for RIDE-6e4c49"
    # }
    #
  end

  @tag :skip
  test "get account balance" do
    devnet = Network.get(:devnet)
    address = "erd1c579aq6kjkhar6cyx8qm9k9wettxjcf3jncduwe0pllqx0rlczfskg3vk2"
    {:ok, acc} = REST.get_address(devnet, address)
    IO.inspect(acc)

    # %{
    #  "address" => "erd1c579aq6kjkhar6cyx8qm9k9wettxjcf3jncduwe0pllqx0rlczfskg3vk2",
    #  "balance" => "9280416133978549558458",
    #  "code" => "",
    #  "codeHash" => nil,
    #  "codeMetadata" => nil,
    #  "developerReward" => "0",
    #  "nonce" => 181,
    #  "ownerAddress" => "",
    #  "rootHash" => "rt0E3avL6eSmhCwb0W/bjBeLUXDoHMiZlIg5pYvcBGo=",
    #  "username" => ""
    # }
  end

  @tag :skip
  test "get tokens" do
    devnet = Network.get(:devnet)
    address = "erd1c579aq6kjkhar6cyx8qm9k9wettxjcf3jncduwe0pllqx0rlczfskg3vk2"
    {:ok, tokens} = AccountState.get_tokens(address, devnet)
    # IO.inspect(tokens)

    json = Jason.encode!(tokens, pretty: true)
    IO.puts(json)

    # [
    #  {
    #    "balance": "9280416133978549558458",
    #    "identifier": "EGLD",
    #    "name": "Native EGLD token"
    #  },
    #  {
    #    "balance": "200000000000000000",
    #    "identifier": "XZPAY-ab2d80",
    #    "name": "Name for XZPAY-ab2d80"
    #  },
    #  {
    #    "balance": "6826076761875767981",
    #    "identifier": "WEGLD-d7c6bb",
    #    "name": "Name for WEGLD-d7c6bb"
    #  },
    #  {
    #    "balance": "2927152819462113",
    #    "identifier": "WEB-5d08be",
    #    "name": "Name for WEB-5d08be"
    #  }
    # ]
  end

  # @tag :skip
  test "get current version" do
    devnet = Network.get(:devnet)
    address = "erd1c579aq6kjkhar6cyx8qm9k9wettxjcf3jncduwe0pllqx0rlczfskg3vk2"
    {:ok, version} = AccountState.get_current(address, devnet)
    # IO.inspect(version)

    json = Jason.encode!(version, pretty: true)
    IO.puts(json)
  end
end
