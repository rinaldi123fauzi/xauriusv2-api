require "application_system_test_case"

class WithdrawsTest < ApplicationSystemTestCase
  setup do
    @withdraw = withdraws(:one)
  end

  test "visiting the index" do
    visit withdraws_url
    assert_selector "h1", text: "Withdraws"
  end

  test "should create withdraw" do
    visit withdraws_url
    click_on "New withdraw"

    fill_in "Account number", with: @withdraw.account_number
    fill_in "Ammount", with: @withdraw.ammount
    fill_in "Cash balance", with: @withdraw.cash_balance
    fill_in "Name bank", with: @withdraw.name_bank
    click_on "Create Withdraw"

    assert_text "Withdraw was successfully created"
    click_on "Back"
  end

  test "should update Withdraw" do
    visit withdraw_url(@withdraw)
    click_on "Edit this withdraw", match: :first

    fill_in "Account number", with: @withdraw.account_number
    fill_in "Ammount", with: @withdraw.ammount
    fill_in "Cash balance", with: @withdraw.cash_balance
    fill_in "Name bank", with: @withdraw.name_bank
    click_on "Update Withdraw"

    assert_text "Withdraw was successfully updated"
    click_on "Back"
  end

  test "should destroy Withdraw" do
    visit withdraw_url(@withdraw)
    click_on "Destroy this withdraw", match: :first

    assert_text "Withdraw was successfully destroyed"
  end
end
