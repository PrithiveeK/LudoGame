class Game::JoinStart
    def self.call(*args, &block)
        new(*args, &block).execute
    end

    def initialize(room_code, player:)
        @room_code = room_code
        @player = player
        @room_channel = "game_channel:#{room_code}"
        @game = Invite.find_by_code(room_code).game
        @dice_value = 0
    end

    def execute
        ActionCable.server.broadcast(
            @room_channel,
            data: "#{@player.username} has joined the game"
        )
        @player.find_invite_by_code(@room_code).update_attribute(:claimed, true)
        if Invite.can_start?(@room_code) || true
            GameChannel.broadcast_to(
                @player,
                action: "start",
                payload: fetch_game_data
            ) 
        end
        # GameCommsJob.set(wait: 2.minutes).perform_now("start", fetch_game_data, to_where: @player)
    end

    def move_piece(data)
        ActionCable.server.broadcast(
            @room_channel,
            action: "move_piece",
            payload: data
        )
        @dice_value = 0
    end

    def roll_dice(data)
        GameCommsJob.perform_now("rolling", data, to_where: @room_channel)
        @dice_value = ((rand * 9876543210).to_i % 6) + 1
        data[:dice] = @dice_value
        GameCommsJob.perform_now("dice_rolled", data, to_where: @room_channel)
    end

    def dice_rolled(data)
        @dice_value = data[:dice]
    end

    def fetch_game_data
        return {
            you: which_player,
            currentPlayer: 1,
            noOfPlayers: no_of_players,
            noOfPlayersFinished: no_of_players_finished
        }
    end

    def next_player(data)
        ActionCable.server.broadcast(
            @room_channel,
            action: "next_player",
            payload: data
        )
    end

    def which_player
        @game.which_player(@player.id)
    end
    def no_of_players
        @game.no_of_players
    end

    def no_of_players_finished
        @game.no_of_players_finished
    end

    
end