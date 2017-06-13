require 'test_helper'

class DeviceMailerTest < ActionMailer::TestCase
  test "new_device" do
    mail = DeviceMailer.new_device
    assert_equal "New device", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
