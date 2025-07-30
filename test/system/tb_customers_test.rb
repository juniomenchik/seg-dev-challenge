require "application_system_test_case"

class TbCustomersTest < ApplicationSystemTestCase
  setup do
    @tb_customer = tb_customers(:one)
  end

  test "visiting the index" do
    visit tb_customers_url
    assert_selector "h1", text: "Tb customers"
  end

  test "should create tb customer" do
    visit tb_customers_url
    click_on "New tb customer"

    fill_in "Id", with: @tb_customer.id
    fill_in "Password digest", with: @tb_customer.password_digest
    fill_in "Role", with: @tb_customer.role
    fill_in "Username", with: @tb_customer.username
    click_on "Create Tb customer"

    assert_text "Tb customer was successfully created"
    click_on "Back"
  end

  test "should update Tb customer" do
    visit tb_customer_url(@tb_customer)
    click_on "Edit this tb customer", match: :first

    fill_in "Id", with: @tb_customer.id
    fill_in "Password digest", with: @tb_customer.password_digest
    fill_in "Role", with: @tb_customer.role
    fill_in "Username", with: @tb_customer.username
    click_on "Update Tb customer"

    assert_text "Tb customer was successfully updated"
    click_on "Back"
  end

  test "should destroy Tb customer" do
    visit tb_customer_url(@tb_customer)
    click_on "Destroy this tb customer", match: :first

    assert_text "Tb customer was successfully destroyed"
  end
end
