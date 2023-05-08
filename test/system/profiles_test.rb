require "application_system_test_case"

class ProfilesTest < ApplicationSystemTestCase
  setup do
    @profile = profiles(:one)
  end

  test "visiting the index" do
    visit profiles_url
    assert_selector "h1", text: "Profiles"
  end

  test "should create profile" do
    visit profiles_url
    click_on "New profile"

    fill_in "Address", with: @profile.address
    fill_in "Deposit", with: @profile.deposit
    fill_in "Full name", with: @profile.full_name
    fill_in "Id number", with: @profile.id_number
    fill_in "Npwp number", with: @profile.npwp_number
    fill_in "Phone number", with: @profile.phone_number
    click_on "Create Profile"

    assert_text "Profile was successfully created"
    click_on "Back"
  end

  test "should update Profile" do
    visit profile_url(@profile)
    click_on "Edit this profile", match: :first

    fill_in "Address", with: @profile.address
    fill_in "Deposit", with: @profile.deposit
    fill_in "Full name", with: @profile.full_name
    fill_in "Id number", with: @profile.id_number
    fill_in "Npwp number", with: @profile.npwp_number
    fill_in "Phone number", with: @profile.phone_number
    click_on "Update Profile"

    assert_text "Profile was successfully updated"
    click_on "Back"
  end

  test "should destroy Profile" do
    visit profile_url(@profile)
    click_on "Destroy this profile", match: :first

    assert_text "Profile was successfully destroyed"
  end
end
