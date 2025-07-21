require "application_system_test_case"

class PublishingHousesTest < ApplicationSystemTestCase
  setup do
    @publishing_house = publishing_houses(:one)
  end

  test "visiting the index" do
    visit publishing_houses_url
    assert_selector "h1", text: "Publishing houses"
  end

  test "should create publishing house" do
    visit publishing_houses_url
    click_on "New publishing house"

    fill_in "Description", with: @publishing_house.description
    fill_in "Name", with: @publishing_house.name
    fill_in "User", with: @publishing_house.user_id
    click_on "Create Publishing house"

    assert_text "Publishing house was successfully created"
    click_on "Back"
  end

  test "should update Publishing house" do
    visit publishing_house_url(@publishing_house)
    click_on "Edit this publishing house", match: :first

    fill_in "Description", with: @publishing_house.description
    fill_in "Name", with: @publishing_house.name
    fill_in "User", with: @publishing_house.user_id
    click_on "Update Publishing house"

    assert_text "Publishing house was successfully updated"
    click_on "Back"
  end

  test "should destroy Publishing house" do
    visit publishing_house_url(@publishing_house)
    click_on "Destroy this publishing house", match: :first

    assert_text "Publishing house was successfully destroyed"
  end
end
