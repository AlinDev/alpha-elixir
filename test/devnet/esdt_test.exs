defmodule Devnet.EsdtTest do
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}
  alias Xprover.Test.{Alice, Bob}
  alias Xprover.Token

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
end
