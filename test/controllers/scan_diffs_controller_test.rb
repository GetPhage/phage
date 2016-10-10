require 'test_helper'

class ScanDiffsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scan_diff = scan_diffs(:one)
  end

  test "should get index" do
    get scan_diffs_url
    assert_response :success
  end

  test "should get new" do
    get new_scan_diff_url
    assert_response :success
  end

  test "should create scan_diff" do
    assert_difference('ScanDiff.count') do
      post scan_diffs_url, params: { scan_diff: { device_id: @scan_diff.device_id, extra: @scan_diff.extra, kind: @scan_diff.kind, scan_id: @scan_diff.scan_id, status: @scan_diff.status } }
    end

    assert_redirected_to scan_diff_url(ScanDiff.last)
  end

  test "should show scan_diff" do
    get scan_diff_url(@scan_diff)
    assert_response :success
  end

  test "should get edit" do
    get edit_scan_diff_url(@scan_diff)
    assert_response :success
  end

  test "should update scan_diff" do
    patch scan_diff_url(@scan_diff), params: { scan_diff: { device_id: @scan_diff.device_id, extra: @scan_diff.extra, kind: @scan_diff.kind, scan_id: @scan_diff.scan_id, status: @scan_diff.status } }
    assert_redirected_to scan_diff_url(@scan_diff)
  end

  test "should destroy scan_diff" do
    assert_difference('ScanDiff.count', -1) do
      delete scan_diff_url(@scan_diff)
    end

    assert_redirected_to scan_diffs_url
  end
end
