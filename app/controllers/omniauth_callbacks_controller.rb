class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include ActionController::Cookies
    def facebook
        puts "facebook",request.env["omniauth.auth"],"end"
        render json: request.env["omniauth.auth"]
        # @user = User.from_omniauth(request.env["omniauth.auth"])
        # if @user.presisted?
        #     UserRecord.create!(user_id: @user.id) unless @user.user_record
        #     sign_in @user, :authentication
        #     render :created
        # else
        #     render json: { done: false }
        # end
    end

    def failure
        render json: { done: false }
    end
end