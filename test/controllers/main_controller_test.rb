require "test_helper"

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get main_index_url
    assert_response :success
  end

  test "should get categories" do
    get main_categories_url
    assert_response :success
  end

  test "should get search" do
    get main_search_url
    assert_response :success
  end

  test "should get category" do
    get main_category_url
    assert_response :success
  end

  test "should get article" do
    get main_article_url
    assert_response :success
  end
end
