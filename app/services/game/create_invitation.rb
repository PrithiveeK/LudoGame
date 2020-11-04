class Game::CreateInvitation
    def self.call(*args, &block)
        new(*args, &block).execute
    end

    def initialize(params, created_by:)
      @params = params
      @user = created_by
    end

    def execute
        @game = Game.new(game_params)
        if @game.save
            GameRecord.create(game_id: @game.id)
            create_invite
        else
            false
        end
    end

    def create_invite
        @invite = Invite.new
        @invite.game_id = @game.id
        @invite.code = Devise.friendly_token
        @invite.created_by_id = @user.id
        if @invite.save
            invite_and_notify_players
            schedule_notification if @game.scheduled_at > DateTime.now
            true
        else
            false
        end
    end

    def invite_and_notify_players
        invite_and_notify @game.player1
        invite_and_notify @game.player2
        invite_and_notify @game.player3 unless @game.player3
        invite_and_notify @game.player4 unless @game.player4
    end

    def schedule_notification
        notify_after @game.player1
        notify_after @game.player2
        notify_after @game.player3 unless @game.player3
        notify_after @game.player4 unless @game.player4
    end

    private

    def invite_and_notify(player)
        InvitedPlayer.create(invite_id: @invite.id, user_id: player.id)
        NotifyUserJob.perform_now(
            "You are being invited to a game by #{@user.username}",
            to_whom: player
        )
    end

    def notifi_after(player)
        NotifyUserJob.set(wait: scheduled_at_params).perform_now(
            "Your game with #{@user.username} is started enter within #{@params.join_window} minutes",
            to_whom: player
        )
    end

    def game_params
        {
            room: @params[:room_name],
            scheduled_at: scheduled_at_params,
            join_window: join_window_params,
            player1_id: @params[:player1_id],
            player2_id: @params[:player2_id],
            player3_id: @params[:player3_id],
            player4_id: @params[:player4_id]
        }   
    end
    
    def scheduled_at_params
        @params[:scheduled_at].to_datetime
    end

    def join_window_params
        scheduled_at_params + @params[:join_window].minutes
    end
end