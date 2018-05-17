class DeviceMailer < ApplicationMailer
  default from: 'phage@romkey.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.device_mailer.new_device.subject
  #
  def new_device(device)
    @greeting = "Hi"

    mail to: "romkey@romkey.com", subject: "Hello from Phage", from: "phage@romkey.com"
  end
end
