require "test_helper"

class AccountControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get account_login_url
    assert_response :success
  end

  test "should get logout" do
    get account_logout_url
    assert_response :success
  end

  test "should get register" do
    get account_register_url
    assert_response :success
  end

  test "should get settings" do
    get account_settings_url
    assert_response :success
  end

  test "should get delete" do
    get account_delete_url
    assert_response :success
  end
end
