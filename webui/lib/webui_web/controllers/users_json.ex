defmodule WebuiWeb.UsersJSON do
  # alias Webui.Accounts.Users

  @doc """
  Renders a list of accounts.
  """
  def index(%{accounts: accounts}) do
    %{data: for(users <- accounts, do: data(users))}
  end

  @doc """
  Renders a single users.
  """
  def show(%{users: users}) do
    %{data: data(users)}
  end

  defp data(users) do
    %{
      id: users.id
    }
  end
end
