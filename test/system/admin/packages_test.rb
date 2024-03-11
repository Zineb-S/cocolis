require "application_system_test_case"

class Admin::PackagesTest < ApplicationSystemTestCase
  setup do
    @admin_package = admin_packages(:one)
  end

  test "visiting the index" do
    visit admin_packages_url
    assert_selector "h1", text: "Packages"
  end

  test "should create package" do
    visit admin_packages_url
    click_on "New package"

    check "Active" if @admin_package.active
    fill_in "Category", with: @admin_package.category_id
    fill_in "Description", with: @admin_package.description
    fill_in "Name", with: @admin_package.name
    fill_in "Price", with: @admin_package.price
    click_on "Create Package"

    assert_text "Package was successfully created"
    click_on "Back"
  end

  test "should update Package" do
    visit admin_package_url(@admin_package)
    click_on "Edit this package", match: :first

    check "Active" if @admin_package.active
    fill_in "Category", with: @admin_package.category_id
    fill_in "Description", with: @admin_package.description
    fill_in "Name", with: @admin_package.name
    fill_in "Price", with: @admin_package.price
    click_on "Update Package"

    assert_text "Package was successfully updated"
    click_on "Back"
  end

  test "should destroy Package" do
    visit admin_package_url(@admin_package)
    click_on "Destroy this package", match: :first

    assert_text "Package was successfully destroyed"
  end
end
