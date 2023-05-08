require "application_system_test_case"

class SellsTest < ApplicationSystemTestCase
  setup do
    @sell = sells(:one)
  end

  test "visiting the index" do
    visit sells_url
    assert_selector "h1", text: "Sells"
  end

  test "should create sell" do
    visit sells_url
    click_on "New sell"

    fill_in "Date", with: @sell.date
    fill_in "Price", with: @sell.price
    fill_in "Quantity", with: @sell.quantity
    fill_in "Sell", with: @sell.sell
    fill_in "Status", with: @sell.status
    fill_in "Summary", with: @sell.summary
    click_on "Create Sell"

    assert_text "Sell was successfully created"
    click_on "Back"
  end

  test "should update Sell" do
    visit sell_url(@sell)
    click_on "Edit this sell", match: :first

    fill_in "Date", with: @sell.date
    fill_in "Price", with: @sell.price
    fill_in "Quantity", with: @sell.quantity
    fill_in "Sell", with: @sell.sell
    fill_in "Status", with: @sell.status
    fill_in "Summary", with: @sell.summary
    click_on "Update Sell"

    assert_text "Sell was successfully updated"
    click_on "Back"
  end

  test "should destroy Sell" do
    visit sell_url(@sell)
    click_on "Destroy this sell", match: :first

    assert_text "Sell was successfully destroyed"
  end
end
