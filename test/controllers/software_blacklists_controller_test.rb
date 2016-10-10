require 'test_helper'

class SoftwareBlacklistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @software_blacklist = software_blacklists(:one)
  end

  test "should get index" do
    get software_blacklists_url
    assert_response :success
  end

  test "should get new" do
    get new_software_blacklist_url
    assert_response :success
  end

  test "should create software_blacklist" do
    assert_difference('SoftwareBlacklist.count') do
      post software_blacklists_url, params: { software_blacklist: { name: @software_blacklist.name, reason: @software_blacklist.reason, version: @software_blacklist.version } }
    end

    assert_redirected_to software_blacklist_url(SoftwareBlacklist.last)
  end

  test "should show software_blacklist" do
    get software_blacklist_url(@software_blacklist)
    assert_response :success
  end

  test "should get edit" do
    get edit_software_blacklist_url(@software_blacklist)
    assert_response :success
  end

  test "should update software_blacklist" do
    patch software_blacklist_url(@software_blacklist), params: { software_blacklist: { name: @software_blacklist.name, reason: @software_blacklist.reason, version: @software_blacklist.version } }
    assert_redirected_to software_blacklist_url(@software_blacklist)
  end

  test "should destroy software_blacklist" do
    assert_difference('SoftwareBlacklist.count', -1) do
      delete software_blacklist_url(@software_blacklist)
    end

    assert_redirected_to software_blacklists_url
  end
end
