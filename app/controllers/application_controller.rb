class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    protect_from_forgery with: :null_session

    rescue_from CanCan::AccessDenied do |exception|
        render json: {code: 403, error: exception.message}
    end
end
