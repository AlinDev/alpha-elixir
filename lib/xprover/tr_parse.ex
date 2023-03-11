defmodule Xprover.TrParse do
  alias Xprover.{Balance, Token}
  alias Elrondex.{Transaction}

  # "status" => "success"
  # only success transactions
  def parse(_address, %{"status" => status}) when status != "success" do
    {:ok, %{}}
  end

  # Normalize value as integer
  def parse(address, %{"value" => value} = tr) when is_binary(value) do
    case Integer.parse(value) do
      {int_value, ""} when is_integer(int_value) ->
        parse(address, %{tr | "value" => int_value})

      _ ->
        {:error, :invalid_value}
    end
  end

  # Self EGLD transfer
  def parse(address, %{"sender" => address, "receiver" => address, "data" => nil} = tr) do
    {:ok, %{"EGLD" => tr["gasPrice"] * tr["gasUsed"]}}
  end

  # Standard EGLD receiver transfer
  def parse(address, %{"sender" => sender, "receiver" => address, "data" => nil} = tr)
      when sender != address do
    {:ok, %{"EGLD" => tr["value"]}}
  end

  # Self EGLD transfer with data
  def parse(address, %{} = tr) do
    IO.inspect({:unknown, address, tr})
    {:error, :unknown}
  end
end
