class SendNewDeviceEmailJob < ApplicationJob
  queue_as :default

  def perform(device_id)
    device = Device.find device_id
    DeviceMailer.new_device(device).deliver_now
  end
end
