require "test_helper"

class WithdrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @withdraw = withdraws(:one)
  end

  test "should get index" do
    get withdraws_url
    assert_response :success
  end

  test "should get new" do
    get new_withdraw_url
    assert_response :success
  end

  test "should create withdraw" do
    assert_difference("Withdraw.count") do
      post withdraws_url, params: { withdraw: { account_number: @withdraw.account_number, ammount: @withdraw.ammount, cash_balance: @withdraw.cash_balance, name_bank: @withdraw.name_bank } }
    end

    assert_redirected_to withdraw_url(Withdraw.last)
  end

  test "should show withdraw" do
    get withdraw_url(@withdraw)
    assert_response :success
  end

  test "should get edit" do
    get edit_withdraw_url(@withdraw)
    assert_response :success
  end

  test "should update withdraw" do
    patch withdraw_url(@withdraw), params: { withdraw: { account_number: @withdraw.account_number, ammount: @withdraw.ammount, cash_balance: @withdraw.cash_balance, name_bank: @withdraw.name_bank } }
    assert_redirected_to withdraw_url(@withdraw)
  end

  test "should destroy withdraw" do
    assert_difference("Withdraw.count", -1) do
      delete withdraw_url(@withdraw)
    end

    assert_redirected_to withdraws_url
  end
end
