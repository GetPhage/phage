# Preview all emails at http://localhost:3000/rails/mailers/device_mailer
class DeviceMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/device_mailer/new_device
  def new_device
    DeviceMailer.new_device
  end

end
