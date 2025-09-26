require "test_helper"

class BookshopsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bookshops_index_url
    assert_response :success
  end

  test "should get show" do
    get bookshops_show_url
    assert_response :success
  end

  test "should get new" do
    get bookshops_new_url
    assert_response :success
  end

  test "should get create" do
    get bookshops_create_url
    assert_response :success
  end

  test "should get edit" do
    get bookshops_edit_url
    assert_response :success
  end

  test "should get update" do
    get bookshops_update_url
    assert_response :success
  end

  test "should get destroy" do
    get bookshops_destroy_url
    assert_response :success
  end
end
