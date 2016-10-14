require 'test_helper'

class MdnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mdn = mdns(:one)
  end

  test "should get index" do
    get mdns_url
    assert_response :success
  end

  test "should get new" do
    get new_mdn_url
    assert_response :success
  end

  test "should create mdn" do
    assert_difference('Mdn.count') do
      post mdns_url, params: { mdn: { device_id: @mdn.device_id, name: @mdn.name, protocol: @mdn.protocol, service: @mdn.service } }
    end

    assert_redirected_to mdn_url(Mdn.last)
  end

  test "should show mdn" do
    get mdn_url(@mdn)
    assert_response :success
  end

  test "should get edit" do
    get edit_mdn_url(@mdn)
    assert_response :success
  end

  test "should update mdn" do
    patch mdn_url(@mdn), params: { mdn: { device_id: @mdn.device_id, name: @mdn.name, protocol: @mdn.protocol, service: @mdn.service } }
    assert_redirected_to mdn_url(@mdn)
  end

  test "should destroy mdn" do
    assert_difference('Mdn.count', -1) do
      delete mdn_url(@mdn)
    end

    assert_redirected_to mdns_url
  end
end
