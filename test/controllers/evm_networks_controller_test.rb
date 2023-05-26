require "test_helper"

class EvmNetworksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @evm_network = evm_networks(:one)
  end

  test "should get index" do
    get evm_networks_url, as: :json
    assert_response :success
  end

  test "should create evm_network" do
    assert_difference("EvmNetwork.count") do
      post evm_networks_url, params: { evm_network: { chain_id: @evm_network.chain_id, currency_symbol: @evm_network.currency_symbol, explorer: @evm_network.explorer, network_name: @evm_network.network_name, rpc_url: @evm_network.rpc_url } }, as: :json
    end

    assert_response :created
  end

  test "should show evm_network" do
    get evm_network_url(@evm_network), as: :json
    assert_response :success
  end

  test "should update evm_network" do
    patch evm_network_url(@evm_network), params: { evm_network: { chain_id: @evm_network.chain_id, currency_symbol: @evm_network.currency_symbol, explorer: @evm_network.explorer, network_name: @evm_network.network_name, rpc_url: @evm_network.rpc_url } }, as: :json
    assert_response :success
  end

  test "should destroy evm_network" do
    assert_difference("EvmNetwork.count", -1) do
      delete evm_network_url(@evm_network), as: :json
    end

    assert_response :no_content
  end
end
