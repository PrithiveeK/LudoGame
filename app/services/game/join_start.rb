class Game::JoinStart

    PLACE = ['FIRST', 'SECOND', 'THIRD', 'LAST']
    POINTS = [10, 5, 2, 0]


    def self.call(*args, &block)
        new(*args, &block).execute
    end

    def initialize(room_code, player:)
        @room_code = room_code
        @player = player
        @room_channel = "game_channel:#{room_code}"
        @game = Game.find_by_code(room_code)
        @dice_value = 0
    end

    def execute
        ActionCable.server.broadcast(
            @room_channel,
            data: "#{@player.username} has joined the game"
        )
        if @game.room == "self"
            @game.join_all!
        else
            @game.player_joined!(@player.id)
        end
        GameChannel.broadcast_to(
            @player,
            action: "player_info",
            payload: fetch_game_data
        ) 
        if @game.can_start?
            ActionCable.server.broadcast(
                @room_channel,
                action: "start",
                payload: players_piece_positions
            )
        end
        # GameCommsJob.set(wait_until: @game.join_window).perform_now("start", nil, to_where: @room_channel)
    end

    def save_game
        @game.is_saved = true
        @game.save
    end

    def move_piece(data)
        piece(data["whichPlayer"],data["whichPiece"]).move_piece!(data["dice"].to_i)
        ActionCable.server.broadcast(
            @room_channel,
            action: "move_piece",
            payload: data
        )
        player_home(data["whichPlayer"]) if @game.this_player(data["whichPlayer"]).has_finished?
        end_game  if no_of_players - 1 == no_of_players_finished
        @dice_value = 0
    end

    def kill_piece(data)
        piece(data["whichPlayer"],data["whichPiece"]).kill_piece!
        ActionCable.server.broadcast(
            @room_channel,
            action: "kill_piece",
            payload: data
        )
    end

    def end_game
        @game.status = "FINISHED"
        @game.save
        ActionCable.server.broadcast(
            @room_channel,
            action: "end"
        )
    end

    def player_home(which_player)
        @player.user_record.add_points(POINTS[no_of_players_finished])
        @player.user_record.check_and_raise_level
        @game.game_records.player_home!(data["whichPlayer"], PLACE[no_of_players_finished])
        ActionCable.server.broadcast(
            @room_channel,
            action: "player_home",
            payload: {
                whichPlayer: which_player
            }
        )
    end

    def roll_dice(data)
        GameCommsJob.perform_now("rolling", data, to_where: @room_channel)
        @dice_value = ((rand * 9876543210).to_i % 6) + 1
        data[:dice] = @dice_value
        GameCommsJob.perform_now("dice_rolled", data, to_where: @room_channel)
    end

    def fetch_game_data
        return {
            you: players_game_record.which_player,
            currentPlayer: @game.current_player,
            noOfPlayers: no_of_players,
            noOfPlayersFinished: no_of_players_finished,
            onlineMode: @game.room != "self"
        }
    end

    def next_player(data)
        nxt_player = find_next_player
        @game.update_attribute(:current_player, nxt_player)
        ActionCable.server.broadcast(
            @room_channel,
            action: "next_player",
            payload: {
                nextPlayer: @game.current_player
            }
        )
    end

    def players_game_record
        @game.players_game_record(@player.id)
    end
    def no_of_players
        @game.no_of_players
    end

    def no_of_players_finished
        @game.no_of_players_finished
    end

    def find_next_player()
        curr_player = @game.current_player
        players = @game.game_players
        puts players
        curr_player.upto(players.count + curr_player - 1) do |i|
            check_player = players[(i % players.count)]
            return check_player.which_player[/\d/].to_i unless check_player.place
        end
    end

    def players_piece_positions
        players = {}
        @game.game_players.each do |player|
            players[player.which_player] = piece_info(player)
        end
        return players
    end
    
    def piece_info(player)
        {
            piece1: player.piece_position("piece1").last_position,
            piece2: player.piece_position("piece2").last_position,
            piece3: player.piece_position("piece3").last_position,
            piece4: player.piece_position("piece4").last_position
        }
    end

    def piece(which_player, piece_name)
        @game.this_player(which_player).move_records.find_by(piece: piece_name)
    end
end