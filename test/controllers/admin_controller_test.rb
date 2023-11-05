require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_index_url
    assert_response :success
  end

  test "should get edit_article" do
    get admin_edit_article_url
    assert_response :success
  end
end
