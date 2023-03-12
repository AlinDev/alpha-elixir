defmodule WebuiWeb.UsersControllerTest do
  use WebuiWeb.ConnCase

  import Webui.AccountsFixtures

  alias Webui.Accounts.Users

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/accounts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create users" do
    test "renders users when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", users: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", users: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update users" do
    setup [:create_users]

    test "renders users when data is valid", %{conn: conn, users: %Users{id: id} = users} do
      conn = put(conn, ~p"/api/accounts/#{users}", users: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, users: users} do
      conn = put(conn, ~p"/api/accounts/#{users}", users: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete users" do
    setup [:create_users]

    test "deletes chosen users", %{conn: conn, users: users} do
      conn = delete(conn, ~p"/api/accounts/#{users}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/accounts/#{users}")
      end
    end
  end

  defp create_users(_) do
    users = users_fixture()
    %{users: users}
  end
end
