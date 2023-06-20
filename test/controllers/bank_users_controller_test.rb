require "test_helper"

class BankUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bank_user = bank_users(:one)
  end

  test "should get index" do
    get bank_users_url, as: :json
    assert_response :success
  end

  test "should create bank_user" do
    assert_difference("BankUser.count") do
      post bank_users_url, params: { bank_user: { nama_akun: @bank_user.nama_akun, nama_bank: @bank_user.nama_bank, nomor_rekening: @bank_user.nomor_rekening, status: @bank_user.status, user_id: @bank_user.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show bank_user" do
    get bank_user_url(@bank_user), as: :json
    assert_response :success
  end

  test "should update bank_user" do
    patch bank_user_url(@bank_user), params: { bank_user: { nama_akun: @bank_user.nama_akun, nama_bank: @bank_user.nama_bank, nomor_rekening: @bank_user.nomor_rekening, status: @bank_user.status, user_id: @bank_user.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy bank_user" do
    assert_difference("BankUser.count", -1) do
      delete bank_user_url(@bank_user), as: :json
    end

    assert_response :no_content
  end
end
