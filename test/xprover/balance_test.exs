defmodule Xprover.BalanceTest do
  alias Xprover.{Balance, TrParse}
  use ExUnit.Case

  test "add_balance_item" do
    assert Balance.add_balance_item({"t1", "x"}, %{}) == {:error, :invalid_move}
    assert Balance.add_balance_item({"t1", 1}, %{}) == {:ok, %{"t1" => 1}}
    assert Balance.add_balance_item({"t1", 1}, %{"t1" => 0}) == {:ok, %{"t1" => 1}}
    assert Balance.add_balance_item({"t1", 2}, %{"t1" => 1}) == {:ok, %{"t1" => 3}}
    assert Balance.add_balance_item({"t2", 2}, %{"t1" => 1}) == {:ok, %{"t1" => 1, "t2" => 2}}
  end

  test "add_balance_list" do
    assert Balance.add_balance_list([], %{}) == {:ok, %{}}
    assert Balance.add_balance_list([{"t1", 1}], %{}) == {:ok, %{"t1" => 1}}
    assert Balance.add_balance_list([{"t1", 1}, {"t2", 2}], %{}) == {:ok, %{"t1" => 1, "t2" => 2}}

    assert Balance.add_balance_list([{"t1", 1}, {"t2", 2}], %{"t2" => 1, "t3" => 3}) ==
             {:ok, %{"t1" => 1, "t2" => 3, "t3" => 3}}
  end

  test "add_balance" do
    assert Balance.add_balance(%{}, %{}) == {:ok, %{}}
    assert Balance.add_balance(%{"t1" => 1}, %{}) == {:ok, %{"t1" => 1}}
    assert Balance.add_balance(%{"t1" => 1, "t2" => 2}, %{}) == {:ok, %{"t1" => 1, "t2" => 2}}

    assert Balance.add_balance(%{"t1" => 1, "t2" => 2}, %{"t2" => 1, "t3" => 3}) ==
             {:ok, %{"t1" => 1, "t2" => 3, "t3" => 3}}
  end
end
