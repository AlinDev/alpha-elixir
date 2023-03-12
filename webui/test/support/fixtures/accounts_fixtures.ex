defmodule Webui.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Webui.Accounts` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{})
      |> Webui.Accounts.create_users()

    users
  end
end
