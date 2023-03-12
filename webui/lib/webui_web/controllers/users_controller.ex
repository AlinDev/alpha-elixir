defmodule WebuiWeb.UsersController do
  alias Xprover.{AccountState, Token, TrParse, Balance}
  alias Elrondex.{Network, Faucet, Transaction, REST, Account}

  use WebuiWeb, :controller

  alias Webui.Accounts
  # alias Webui.Accounts.Users

  action_fallback WebuiWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def show(conn, %{"address" => address}) do
    users = Accounts.get_users!(address)
    devnet = Network.get(:devnet)

    # conn = put_resp_header(conn, "Access-Control-Allow-Origin", "*")

    with {:ok, current_acc} <- AccountState.get_current(address, devnet),
         {:ok, transactions} <- AccountState.get_address_transactions(address, devnet),
         {:ok, versions} <- Balance.calculate_versions(address, transactions) do
      data = %{
        address: address,
        network: :devnet,
        versions: versions
      }

      json(conn, %{success: true, data: data})
    else
      {:error, error} -> json(conn, %{success: false, message: inspect(error)})
    end

    # render(conn, :show, users: users)
  end
end
