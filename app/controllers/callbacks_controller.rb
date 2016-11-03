class CallbacksController < Devise::OmniauthCallbacksController
    def slack
#        team_name = request.env["omniauth.auth"]["info"]["team"]
#        unless [ "Singularity University", "Global Solutions Program 2016" ].include? team_name
#          raise ActionController::RoutingError.new('Not Authorized')
#        end

        @user = User.from_omniauth(request.env["omniauth.auth"])
#        if @user.email && (@user.email.match(/alaina/) || @user.email.match(/romkey/))
#          @user.role = 'admin'
#          @user.save
#        end

#        @user.role = 'participant'
#        @user.save
        sign_in_and_redirect @user
    end
end
