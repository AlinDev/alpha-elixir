ExUnit.start()

Elrondex.Faucet.start_link()

defmodule TestData do
  use ExUnit.Case

  @test_data_path Path.join(__DIR__, "data")

  def test_data_path() do
    @test_data_path
  end

  def network_path(network) when network in [:mainnet, :testnet, :devnet] do
    Path.join(test_data_path(), "#{network}")
  end

  def data_type_path(network, data_type, file) do
    network
    |> network_path()
    |> Path.join("#{data_type}")
    |> Path.join(file)
  end

  def put_data(network, data_type, file, data) when is_binary(data) do
    file_path = data_type_path(network, data_type, file)

    case File.exists?(file_path) do
      false -> File.mkdir_p!(Path.dirname(file_path))
      true -> raise "File #{file_path} exists!"
    end

    File.write!(file_path, data)
  end

  def put_data(network, data_type, file, data) when is_map(data) or is_list(data) do
    json_data = Jason.encode!(data, pretty: true)
    put_data(network, data_type, file, json_data)
  end

  # def assert_tx_data(network, tx_hash, tx_data) when is_map(tx_data) do
  #  tx_file = tx_path(network, tx_hash)
  #
  #  case File.exists?(tx_file) do
  #    false -> put_tx_data(network, tx_hash, tx_data)
  #    true -> assert tx_data == Jason.decode!(File.read!(tx_file))
  #  end
  # end
end

defmodule AssertState do
  alias Elrondex.{REST}
  alias Xprover.AccountState

  use ExUnit.Case

  def get_account_state(network, address, {nonce, version}, tx_hash, balance) do
    {:ok, acc} = REST.get_address(network, address)
    IO.inspect(acc)
    assert acc["balance"] == "#{balance}"
    assert acc["address"] == address
    assert acc["nonce"] == nonce
    %AccountState{nonce: nonce, version: version, balance: balance, tx_hash: tx_hash}
  end
end
