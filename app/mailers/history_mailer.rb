class HistoryMailer < ApplicationMailer
  default from: 'phage@romkey.com'
 
  def activity_email
#    @user = params[:user]
    #    @url  = 'http://example.com/login'
    @history = params[:history]
    mail(to: 'romkey@romkey.com', subject: 'Phage activity', from: 'phage@romkey.com')
  end
end
