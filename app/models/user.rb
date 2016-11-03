class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.update(
        password: Devise.friendly_token[0,20]
      )
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.slack_data"]
        # user.attributes = params
        user.update(
          email: params[:email],
          password: Devise.friendly_token[0,20]
        )
      end
    end
  end
end
