require "test_helper"

class ChroniclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chronicle = chronicles(:one)
  end

  test "should get index" do
    get chronicles_url
    assert_response :success
  end

  test "should get new" do
    get new_chronicle_url
    assert_response :success
  end

  test "should create chronicle" do
    assert_difference("Chronicle.count") do
      post chronicles_url, params: { chronicle: { content: @chronicle.content, title: @chronicle.title, user_id: @chronicle.user_id } }
    end

    assert_redirected_to chronicle_url(Chronicle.last)
  end

  test "should show chronicle" do
    get chronicle_url(@chronicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_chronicle_url(@chronicle)
    assert_response :success
  end

  test "should update chronicle" do
    patch chronicle_url(@chronicle), params: { chronicle: { content: @chronicle.content, title: @chronicle.title, user_id: @chronicle.user_id } }
    assert_redirected_to chronicle_url(@chronicle)
  end

  test "should destroy chronicle" do
    assert_difference("Chronicle.count", -1) do
      delete chronicle_url(@chronicle)
    end

    assert_redirected_to chronicles_url
  end
end
