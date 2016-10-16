require 'test_helper'

class CvesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cfe = cves(:one)
  end

  test "should get index" do
    get cves_url
    assert_response :success
  end

  test "should get new" do
    get new_cfe_url
    assert_response :success
  end

  test "should create cfe" do
    assert_difference('Cve.count') do
      post cves_url, params: { cfe: { comments: @cfe.comments, desc: @cfe.desc, name: @cfe.name, refs: @cfe.refs, seq: @cfe.seq, status: @cfe.status } }
    end

    assert_redirected_to cfe_url(Cve.last)
  end

  test "should show cfe" do
    get cfe_url(@cfe)
    assert_response :success
  end

  test "should get edit" do
    get edit_cfe_url(@cfe)
    assert_response :success
  end

  test "should update cfe" do
    patch cfe_url(@cfe), params: { cfe: { comments: @cfe.comments, desc: @cfe.desc, name: @cfe.name, refs: @cfe.refs, seq: @cfe.seq, status: @cfe.status } }
    assert_redirected_to cfe_url(@cfe)
  end

  test "should destroy cfe" do
    assert_difference('Cve.count', -1) do
      delete cfe_url(@cfe)
    end

    assert_redirected_to cves_url
  end
end
