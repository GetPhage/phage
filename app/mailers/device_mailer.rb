class DeviceMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.device_mailer.new_device.subject
  #
  def new_device(device)
    @greeting = "Hi"

    mail to: "romkey@romkey.com"
  end
end
