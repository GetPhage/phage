require 'test_helper'

class GeoIpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @geo_ip = geo_ips(:one)
  end

  test "should get index" do
    get geo_ips_url
    assert_response :success
  end

  test "should get new" do
    get new_geo_ip_url
    assert_response :success
  end

  test "should create geo_ip" do
    assert_difference('GeoIp.count') do
      post geo_ips_url, params: { geo_ip: { geo_location_id: @geo_ip.geo_location_id, ipaddr: @geo_ip.ipaddr } }
    end

    assert_redirected_to geo_ip_url(GeoIp.last)
  end

  test "should show geo_ip" do
    get geo_ip_url(@geo_ip)
    assert_response :success
  end

  test "should get edit" do
    get edit_geo_ip_url(@geo_ip)
    assert_response :success
  end

  test "should update geo_ip" do
    patch geo_ip_url(@geo_ip), params: { geo_ip: { geo_location_id: @geo_ip.geo_location_id, ipaddr: @geo_ip.ipaddr } }
    assert_redirected_to geo_ip_url(@geo_ip)
  end

  test "should destroy geo_ip" do
    assert_difference('GeoIp.count', -1) do
      delete geo_ip_url(@geo_ip)
    end

    assert_redirected_to geo_ips_url
  end
end
