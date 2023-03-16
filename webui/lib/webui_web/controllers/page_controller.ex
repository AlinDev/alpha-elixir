defmodule WebuiWeb.PageController do
  alias Xprover.{AccountState, Token, TrParse, Balance}
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}

  use WebuiWeb, :controller

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.

    IO.puts("=== WebuiWeb.PageController ===")

    devnet = Network.get(:devnet)
    address = params["address"]

    current =
      case AccountState.get_current(address, devnet) do
        {:ok, valid} -> %{:ok => true, :data => valid, :address => address}
        {:error, error} -> %{:ok => false, message: inspect(error)}
      end

    history =
      with {:ok, current_acc} <- AccountState.get_current(address, devnet),
           {:ok, transactions} <- AccountState.get_address_transactions(address, devnet),
           {:ok, versions} <- Balance.calculate_versions(address, transactions) do
        data = %{
          address: address,
          network: :devnet,
          versions: versions
        }

        %{:ok => true, :data => data}
      else
        {:error, error} -> %{:ok => false, message: inspect(error)}
      end

    render(conn, :home, layout: false, current: current, history: history)
  end
end
