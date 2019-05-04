require 'test_helper'

class CorpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @corp = corps(:one)
  end

  test "should get index" do
    get corps_url
    assert_response :success
  end

  test "should get new" do
    get new_corp_url
    assert_response :success
  end

  test "should create corp" do
    assert_difference('Corp.count') do
      post corps_url, params: { corp: { name: @corp.name, no: @corp.no } }
    end

    assert_redirected_to corp_url(Corp.last)
  end

  test "should show corp" do
    get corp_url(@corp)
    assert_response :success
  end

  test "should get edit" do
    get edit_corp_url(@corp)
    assert_response :success
  end

  test "should update corp" do
    patch corp_url(@corp), params: { corp: { name: @corp.name, no: @corp.no } }
    assert_redirected_to corp_url(@corp)
  end

  test "should destroy corp" do
    assert_difference('Corp.count', -1) do
      delete corp_url(@corp)
    end

    assert_redirected_to corps_url
  end
end
