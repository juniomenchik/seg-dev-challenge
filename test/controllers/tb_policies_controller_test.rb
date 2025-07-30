require "test_helper"

class TbPoliciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tb_policy = tb_policies(:one)
  end

  test "should get index" do
    get tb_policies_url
    assert_response :success
  end

  test "should get new" do
    get new_tb_policy_url
    assert_response :success
  end

  test "should create tb_policy" do
    assert_difference("TbPolicy.count") do
      post tb_policies_url, params: { tb_policy: { end_date: @tb_policy.end_date, policy_number: @tb_policy.policy_number, start_date: @tb_policy.start_date, status: @tb_policy.status, tb_customer_id: @tb_policy.tb_customer_id } }
    end

    assert_redirected_to tb_policy_url(TbPolicy.last)
  end

  test "should show tb_policy" do
    get tb_policy_url(@tb_policy)
    assert_response :success
  end

  test "should get edit" do
    get edit_tb_policy_url(@tb_policy)
    assert_response :success
  end

  test "should update tb_policy" do
    patch tb_policy_url(@tb_policy), params: { tb_policy: { end_date: @tb_policy.end_date, policy_number: @tb_policy.policy_number, start_date: @tb_policy.start_date, status: @tb_policy.status, tb_customer_id: @tb_policy.tb_customer_id } }
    assert_redirected_to tb_policy_url(@tb_policy)
  end

  test "should destroy tb_policy" do
    assert_difference("TbPolicy.count", -1) do
      delete tb_policy_url(@tb_policy)
    end

    assert_redirected_to tb_policies_url
  end
end
