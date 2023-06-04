require "test_helper"

class AuthAdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @auth_admin = auth_admins(:one)
  end

  test "should get index" do
    get auth_admins_url, as: :json
    assert_response :success
  end

  test "should create auth_admin" do
    assert_difference("AuthAdmin.count") do
      post auth_admins_url, params: { auth_admin: { email: @auth_admin.email, name: @auth_admin.name, password: @auth_admin.password, password_digest: @auth_admin.password_digest, username: @auth_admin.username } }, as: :json
    end

    assert_response :created
  end

  test "should show auth_admin" do
    get auth_admin_url(@auth_admin), as: :json
    assert_response :success
  end

  test "should update auth_admin" do
    patch auth_admin_url(@auth_admin), params: { auth_admin: { email: @auth_admin.email, name: @auth_admin.name, password: @auth_admin.password, password_digest: @auth_admin.password_digest, username: @auth_admin.username } }, as: :json
    assert_response :success
  end

  test "should destroy auth_admin" do
    assert_difference("AuthAdmin.count", -1) do
      delete auth_admin_url(@auth_admin), as: :json
    end

    assert_response :no_content
  end
end
