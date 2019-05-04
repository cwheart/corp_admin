require "application_system_test_case"

class CorpsTest < ApplicationSystemTestCase
  setup do
    @corp = corps(:one)
  end

  test "visiting the index" do
    visit corps_url
    assert_selector "h1", text: "Corps"
  end

  test "creating a Corp" do
    visit corps_url
    click_on "New Corp"

    fill_in "Name", with: @corp.name
    fill_in "No", with: @corp.no
    click_on "Create Corp"

    assert_text "Corp was successfully created"
    click_on "Back"
  end

  test "updating a Corp" do
    visit corps_url
    click_on "Edit", match: :first

    fill_in "Name", with: @corp.name
    fill_in "No", with: @corp.no
    click_on "Update Corp"

    assert_text "Corp was successfully updated"
    click_on "Back"
  end

  test "destroying a Corp" do
    visit corps_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Corp was successfully destroyed"
  end
end
