class Game::CreateGame
    def self.call(*args, &block)
        new(*args, &block).execute
    end

    def initialize(params, created_by:)
      @params = params
      @user = User.find(created_by)
    end

    def execute
        @game = Game.new(game_params)
        if @game.save
            invite_and_notify_players
            schedule_notification if @game.scheduled_at > DateTime.now && @game.room != "self"
            @game.code
        else
            nil
        end
    end

    def invite_and_notify_players
        invite_and_notify @params[:player1_id], which_player: "Player1"
        invite_and_notify @params[:player2_id], which_player: "Player2"
        invite_and_notify @params[:player3_id], which_player: "Player3" if @params[:player3_id] != nil
        invite_and_notify @params[:player4_id], which_player: "Player4" if @params[:player4_id] != nil
    end

    def schedule_notification
        notify_after @params[:player1_id]
        notify_after @params[:player2_id]
        notify_after @params[:player3_id] if @params[:player3_id] != nil
        notify_after @params[:player4_id] if @params[:player4_id] != nil
    end

    private

    def invite_and_notify(player_id, which_player:)
        game_record = GameRecord.create(game_id: @game.id, player_id: player_id, which_player: which_player)
        1.upto(4) do |i|
            MoveRecord.create(game_record_id: game_record.id, player: game_record.which_player, piece: "piece#{i}", last_position: -1)
        end
        if @game.room != "self"
            NotifyUserJob.perform_now(
                "You are being invited to a game by #{@user.username}, it starts at #{scheduled_at_params}",
                to_whom: User.find(player_id)
            )
        end
    end

    def notify_after(player)
        NotifyUserJob.set(wait: scheduled_at_params).perform_now(
            "Your game with #{@user.username} is started enter within #{@params[:join_window]} minutes",
            to_whom: User.find(player)
        )
    end

    def game_params
        {
            room: @params[:room_name],
            scheduled_at: scheduled_at_params,
            join_window: join_window_params,
            code: Devise.friendly_token,
            created_by_id: @user.id
        }   
    end
    
    def scheduled_at_params
        @params[:scheduled_at].to_datetime
    end

    def join_window_params
        scheduled_at_params + @params[:join_window].to_i.minutes
    end
end