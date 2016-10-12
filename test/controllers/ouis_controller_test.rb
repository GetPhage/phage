require 'test_helper'

class OuisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @oui = ouis(:one)
  end

  test "should get index" do
    get ouis_url
    assert_response :success
  end

  test "should get new" do
    get new_oui_url
    assert_response :success
  end

  test "should create oui" do
    assert_difference('Oui.count') do
      post ouis_url, params: { oui: { manufacturer: @oui.manufacturer, prefix: @oui.prefix } }
    end

    assert_redirected_to oui_url(Oui.last)
  end

  test "should show oui" do
    get oui_url(@oui)
    assert_response :success
  end

  test "should get edit" do
    get edit_oui_url(@oui)
    assert_response :success
  end

  test "should update oui" do
    patch oui_url(@oui), params: { oui: { manufacturer: @oui.manufacturer, prefix: @oui.prefix } }
    assert_redirected_to oui_url(@oui)
  end

  test "should destroy oui" do
    assert_difference('Oui.count', -1) do
      delete oui_url(@oui)
    end

    assert_redirected_to ouis_url
  end
end
