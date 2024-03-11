require "test_helper"

class Admin::DeliveriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_delivery = admin_deliveries(:one)
  end

  test "should get index" do
    get admin_deliveries_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_delivery_url
    assert_response :success
  end

  test "should create admin_delivery" do
    assert_difference("Admin::Delivery.count") do
      post admin_deliveries_url, params: { admin_delivery: { address: @admin_delivery.address, client_email: @admin_delivery.client_email, driver_email: @admin_delivery.driver_email, fulfilled: @admin_delivery.fulfilled, total: @admin_delivery.total } }
    end

    assert_redirected_to admin_delivery_url(Admin::Delivery.last)
  end

  test "should show admin_delivery" do
    get admin_delivery_url(@admin_delivery)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_delivery_url(@admin_delivery)
    assert_response :success
  end

  test "should update admin_delivery" do
    patch admin_delivery_url(@admin_delivery), params: { admin_delivery: { address: @admin_delivery.address, client_email: @admin_delivery.client_email, driver_email: @admin_delivery.driver_email, fulfilled: @admin_delivery.fulfilled, total: @admin_delivery.total } }
    assert_redirected_to admin_delivery_url(@admin_delivery)
  end

  test "should destroy admin_delivery" do
    assert_difference("Admin::Delivery.count", -1) do
      delete admin_delivery_url(@admin_delivery)
    end

    assert_redirected_to admin_deliveries_url
  end
end
