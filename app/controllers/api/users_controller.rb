class Api::UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:facebook]

    def index
        @all_users = User.all
        render :index, status: :ok
    end

    def verify
        begin
            @user = current_user
            render :verify
        rescue => exception
            render json: { verified: false }
        end
    end

    def facebook
        @user = User::FromOauth.create(params[:access_token])
        if @user
            sign_in(@user, scope: :user)
            render :show
        else
            render json: {message: 'Email already exists'}
        end
    end
end
