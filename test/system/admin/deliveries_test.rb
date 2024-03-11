require "application_system_test_case"

class Admin::DeliveriesTest < ApplicationSystemTestCase
  setup do
    @admin_delivery = admin_deliveries(:one)
  end

  test "visiting the index" do
    visit admin_deliveries_url
    assert_selector "h1", text: "Deliveries"
  end

  test "should create delivery" do
    visit admin_deliveries_url
    click_on "New delivery"

    fill_in "Address", with: @admin_delivery.address
    fill_in "Client email", with: @admin_delivery.client_email
    fill_in "Driver email", with: @admin_delivery.driver_email
    check "Fulfilled" if @admin_delivery.fulfilled
    fill_in "Total", with: @admin_delivery.total
    click_on "Create Delivery"

    assert_text "Delivery was successfully created"
    click_on "Back"
  end

  test "should update Delivery" do
    visit admin_delivery_url(@admin_delivery)
    click_on "Edit this delivery", match: :first

    fill_in "Address", with: @admin_delivery.address
    fill_in "Client email", with: @admin_delivery.client_email
    fill_in "Driver email", with: @admin_delivery.driver_email
    check "Fulfilled" if @admin_delivery.fulfilled
    fill_in "Total", with: @admin_delivery.total
    click_on "Update Delivery"

    assert_text "Delivery was successfully updated"
    click_on "Back"
  end

  test "should destroy Delivery" do
    visit admin_delivery_url(@admin_delivery)
    click_on "Destroy this delivery", match: :first

    assert_text "Delivery was successfully destroyed"
  end
end
