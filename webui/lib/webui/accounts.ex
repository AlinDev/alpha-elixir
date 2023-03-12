defmodule Webui.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Webui.Repo

  # alias Webui.Accounts.Users

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Users{}, ...]

  """
  def list_accounts do
    raise "TODO"
  end

  @doc """
  Gets a single users.

  Raises if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

  """
  def get_users!(id) do
    %{
      id: id
    }
  end

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, ...}

  """
  def create_users(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, ...}

  """
  def update_users(users, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, ...}

  """
  def delete_users(users) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Todo{...}

  """
  def change_users(users, _attrs \\ %{}) do
    raise "TODO"
  end
end
