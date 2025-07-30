require "test_helper"

class TbCustomersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tb_customer = tb_customers(:one)
  end

  test "should get index" do
    get tb_customers_url
    assert_response :success
  end

  test "should get new" do
    get new_tb_customer_url
    assert_response :success
  end

  test "should create tb_customer" do
    assert_difference("TbCustomer.count") do
      post tb_customers_url, params: { tb_customer: { id: @tb_customer.id, password: @tb_customer.password_digest, role: @tb_customer.role, username: @tb_customer.username } }
    end

    assert_redirected_to tb_customer_url(TbCustomer.last)
  end

  test "should show tb_customer" do
    get tb_customer_url(@tb_customer)
    assert_response :success
  end

  test "should get edit" do
    get edit_tb_customer_url(@tb_customer)
    assert_response :success
  end

  test "should update tb_customer" do
    patch tb_customer_url(@tb_customer), params: { tb_customer: { id: @tb_customer.id, password: @tb_customer.password_digest, role: @tb_customer.role, username: @tb_customer.username } }
    assert_redirected_to tb_customer_url(@tb_customer)
  end

  test "should destroy tb_customer" do
    assert_difference("TbCustomer.count", -1) do
      delete tb_customer_url(@tb_customer)
    end

    assert_redirected_to tb_customers_url
  end
end
