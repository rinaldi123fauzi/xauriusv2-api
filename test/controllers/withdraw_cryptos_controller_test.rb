require "test_helper"

class WithdrawCryptosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @withdraw_crypto = withdraw_cryptos(:one)
  end

  test "should get index" do
    get withdraw_cryptos_url, as: :json
    assert_response :success
  end

  test "should create withdraw_crypto" do
    assert_difference("WithdrawCrypto.count") do
      post withdraw_cryptos_url, params: { withdraw_crypto: { account_number: @withdraw_crypto.account_number, name: @withdraw_crypto.name, name_bank: @withdraw_crypto.name_bank, status: @withdraw_crypto.status, user_id: @withdraw_crypto.user_id, xau_amount: @withdraw_crypto.xau_amount } }, as: :json
    end

    assert_response :created
  end

  test "should show withdraw_crypto" do
    get withdraw_crypto_url(@withdraw_crypto), as: :json
    assert_response :success
  end

  test "should update withdraw_crypto" do
    patch withdraw_crypto_url(@withdraw_crypto), params: { withdraw_crypto: { account_number: @withdraw_crypto.account_number, name: @withdraw_crypto.name, name_bank: @withdraw_crypto.name_bank, status: @withdraw_crypto.status, user_id: @withdraw_crypto.user_id, xau_amount: @withdraw_crypto.xau_amount } }, as: :json
    assert_response :success
  end

  test "should destroy withdraw_crypto" do
    assert_difference("WithdrawCrypto.count", -1) do
      delete withdraw_crypto_url(@withdraw_crypto), as: :json
    end

    assert_response :no_content
  end
end
