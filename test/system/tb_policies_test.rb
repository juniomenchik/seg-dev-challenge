require "application_system_test_case"

class TbPoliciesTest < ApplicationSystemTestCase
  setup do
    @tb_policy = tb_policies(:one)
  end

  test "visiting the index" do
    visit tb_policies_url
    assert_selector "h1", text: "Tb policies"
  end

  test "should create tb policy" do
    visit tb_policies_url
    click_on "New tb policy"

    fill_in "End date", with: @tb_policy.end_date
    fill_in "Policy number", with: @tb_policy.policy_number
    fill_in "Start date", with: @tb_policy.start_date
    fill_in "Status", with: @tb_policy.status
    fill_in "Tb customer", with: @tb_policy.tb_customer_id
    click_on "Create Tb policy"

    assert_text "Tb policy was successfully created"
    click_on "Back"
  end

  test "should update Tb policy" do
    visit tb_policy_url(@tb_policy)
    click_on "Edit this tb policy", match: :first

    fill_in "End date", with: @tb_policy.end_date.to_s
    fill_in "Policy number", with: @tb_policy.policy_number
    fill_in "Start date", with: @tb_policy.start_date.to_s
    fill_in "Status", with: @tb_policy.status
    fill_in "Tb customer", with: @tb_policy.tb_customer_id
    click_on "Update Tb policy"

    assert_text "Tb policy was successfully updated"
    click_on "Back"
  end

  test "should destroy Tb policy" do
    visit tb_policy_url(@tb_policy)
    click_on "Destroy this tb policy", match: :first

    assert_text "Tb policy was successfully destroyed"
  end
end
