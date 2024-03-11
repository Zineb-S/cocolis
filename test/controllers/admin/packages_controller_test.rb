require "test_helper"

class Admin::PackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_package = admin_packages(:one)
  end

  test "should get index" do
    get admin_packages_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_package_url
    assert_response :success
  end

  test "should create admin_package" do
    assert_difference("Admin::Package.count") do
      post admin_packages_url, params: { admin_package: { active: @admin_package.active, category_id: @admin_package.category_id, description: @admin_package.description, name: @admin_package.name, price: @admin_package.price } }
    end

    assert_redirected_to admin_package_url(Admin::Package.last)
  end

  test "should show admin_package" do
    get admin_package_url(@admin_package)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_package_url(@admin_package)
    assert_response :success
  end

  test "should update admin_package" do
    patch admin_package_url(@admin_package), params: { admin_package: { active: @admin_package.active, category_id: @admin_package.category_id, description: @admin_package.description, name: @admin_package.name, price: @admin_package.price } }
    assert_redirected_to admin_package_url(@admin_package)
  end

  test "should destroy admin_package" do
    assert_difference("Admin::Package.count", -1) do
      delete admin_package_url(@admin_package)
    end

    assert_redirected_to admin_packages_url
  end
end
