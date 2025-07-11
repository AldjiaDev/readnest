require "application_system_test_case"

class ChroniclesTest < ApplicationSystemTestCase
  setup do
    @chronicle = chronicles(:one)
  end

  test "visiting the index" do
    visit chronicles_url
    assert_selector "h1", text: "Chronicles"
  end

  test "should create chronicle" do
    visit chronicles_url
    click_on "New chronicle"

    fill_in "Content", with: @chronicle.content
    fill_in "Title", with: @chronicle.title
    fill_in "User", with: @chronicle.user_id
    click_on "Create Chronicle"

    assert_text "Chronicle was successfully created"
    click_on "Back"
  end

  test "should update Chronicle" do
    visit chronicle_url(@chronicle)
    click_on "Edit this chronicle", match: :first

    fill_in "Content", with: @chronicle.content
    fill_in "Title", with: @chronicle.title
    fill_in "User", with: @chronicle.user_id
    click_on "Update Chronicle"

    assert_text "Chronicle was successfully updated"
    click_on "Back"
  end

  test "should destroy Chronicle" do
    visit chronicle_url(@chronicle)
    click_on "Destroy this chronicle", match: :first

    assert_text "Chronicle was successfully destroyed"
  end
end
