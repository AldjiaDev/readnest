require "test_helper"

class PublishingHousesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publishing_house = publishing_houses(:one)
  end

  test "should get index" do
    get publishing_houses_url
    assert_response :success
  end

  test "should get new" do
    get new_publishing_house_url
    assert_response :success
  end

  test "should create publishing_house" do
    assert_difference("PublishingHouse.count") do
      post publishing_houses_url, params: { publishing_house: { description: @publishing_house.description, name: @publishing_house.name, user_id: @publishing_house.user_id } }
    end

    assert_redirected_to publishing_house_url(PublishingHouse.last)
  end

  test "should show publishing_house" do
    get publishing_house_url(@publishing_house)
    assert_response :success
  end

  test "should get edit" do
    get edit_publishing_house_url(@publishing_house)
    assert_response :success
  end

  test "should update publishing_house" do
    patch publishing_house_url(@publishing_house), params: { publishing_house: { description: @publishing_house.description, name: @publishing_house.name, user_id: @publishing_house.user_id } }
    assert_redirected_to publishing_house_url(@publishing_house)
  end

  test "should destroy publishing_house" do
    assert_difference("PublishingHouse.count", -1) do
      delete publishing_house_url(@publishing_house)
    end

    assert_redirected_to publishing_houses_url
  end
end
