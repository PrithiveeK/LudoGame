class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]
    before_action :configure_account_update_params, only: [:create]
    respond_to :json

    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    end

    def configure_account_update_params
        devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    end

    protected

    def after_sign_up_path_for(resource)
        UserRecord.create!(user_id: resource.id, is_online: true) unless resource.user_record
        super
    end

    private

    def respond_with(resource, _opts = {})
        @user = resource
        @user.user_record = UserRecord.find_by(user_id: @user.id)
        render :created
    end
end