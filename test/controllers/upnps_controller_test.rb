require 'test_helper'

class UpnpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upnp = upnps(:one)
  end

  test "should get index" do
    get upnps_url
    assert_response :success
  end

  test "should get new" do
    get new_upnp_url
    assert_response :success
  end

  test "should create upnp" do
    assert_difference('Upnp.count') do
      post upnps_url, params: { upnp: { cache_control: @upnp.cache_control, device_id: @upnp.device_id, ext: @upnp.ext, location: @upnp.location, server: @upnp.server, st: @upnp.st, usn: @upnp.usn } }
    end

    assert_redirected_to upnp_url(Upnp.last)
  end

  test "should show upnp" do
    get upnp_url(@upnp)
    assert_response :success
  end

  test "should get edit" do
    get edit_upnp_url(@upnp)
    assert_response :success
  end

  test "should update upnp" do
    patch upnp_url(@upnp), params: { upnp: { cache_control: @upnp.cache_control, device_id: @upnp.device_id, ext: @upnp.ext, location: @upnp.location, server: @upnp.server, st: @upnp.st, usn: @upnp.usn } }
    assert_redirected_to upnp_url(@upnp)
  end

  test "should destroy upnp" do
    assert_difference('Upnp.count', -1) do
      delete upnp_url(@upnp)
    end

    assert_redirected_to upnps_url
  end
end
