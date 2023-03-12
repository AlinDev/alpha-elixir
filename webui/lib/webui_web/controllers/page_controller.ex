defmodule WebuiWeb.PageController do
  alias Xprover.{AccountState, Token, TrParse, Balance}
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}

  use WebuiWeb, :controller

  def home(conn, params) do
    # The home page is often custom made,
    # so skip the default app layout.

    IO.puts("=== WebuiWeb.PageController ===")

    devnet = Network.get(:devnet)

    current =
      case AccountState.get_current(params["address"], devnet) do
        {:ok, valid} -> %{:ok => true, :data => valid}
        {:error, error} -> %{:ok => false, message: inspect(error)}
      end

    render(conn, :home, layout: false, current: current)
  end
end
