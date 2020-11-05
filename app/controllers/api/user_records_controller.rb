class Api::UserRecordsController < ApplicationController

    def leaderboard
        @user_records = UserRecord.order(:points)
        render :leaderboard
    end

    def my_stats
        @cu = current_user
        @user_stats = @cu.game_records
    end

    def update_avatar
        user_record = UserRecord.find(params[:user_id])
        authorize! :update, user_record
        user_record.avatar = params[:avatar]
        if user_record.save
            render json: { done: true, avatar: user_record.avatar }
            NotifyUserJob.perform_now("User: #{current_user.username} changed avatar", to_whom: current_user)
        else
            render json: { done: false }
        end
    end
end
