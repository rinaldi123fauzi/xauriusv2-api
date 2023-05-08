require "test_helper"

class BusinessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = businesses(:one)
  end

  test "should get index" do
    get businesses_url, as: :json
    assert_response :success
  end

  test "should create business" do
    assert_difference("Business.count") do
      post businesses_url, params: { business: { nama_usaha: @business.nama_usaha, user_id: @business.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show business" do
    get business_url(@business), as: :json
    assert_response :success
  end

  test "should update business" do
    patch business_url(@business), params: { business: { nama_usaha: @business.nama_usaha, user_id: @business.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy business" do
    assert_difference("Business.count", -1) do
      delete business_url(@business), as: :json
    end

    assert_response :no_content
  end
end
