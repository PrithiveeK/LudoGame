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
            GameCommsJob.perform_now(
                "start",
                players_piece_positions,
                to_where: @room_channel
            )
        end
        # GameCommsJob.set(wait_until: @game.join_window).perform_now("start", nil, to_where: @room_channel)
    end

    def save_game
        @game.is_saved = true
        @game.save
    end

    def roll_dice(data)
        GameCommsJob.perform_now("rolling", data, to_where: @room_channel)
        @dice_value = ((rand * 9876543210).to_i % 6) + 1
        data[:dice] = @dice_value
        dice["nextPlayer"] = next_player
        dice["choosePiece"] = !(player_move_records.pieces_out == 0 && @dice_value != 6)
        GameCommsJob.perform_now("dice_rolled", data, to_where: @room_channel)
    end

    def move_piece(data)
        current_player_piece = piece(data["whichPlayer"],data["whichPiece"])
        current_player_piece.move_piece!(@dice_value)
        GameCommsJob.perform_now(
            "move_piece",
            {
                whichPlayer: data["whichPlayer"],
                whichPiece: data["whichPiece"],
                dice: @dice_value,
                nextPlayer: next_player
            },
            to_where: @room_channel
        )
        can_i_kill(current_player_piece)
        player_home(data["whichPlayer"]) if @game.this_player(data["whichPlayer"]).has_finished?
        end_game if no_of_players - 1 == no_of_players_finished
        @dice_value = 0
    end

    def can_i_kill(current_player_piece)
        pieces_out = @game.move_records.pieces_out_except_mine(players_game_record.which_player)
        pieces_out.each do |killable_piece|
            kill_piece if can_kill_piece?(current_player_piece, killable_piece)
        end
    end

    def can_kill_piece?(piece1, piece2)
        piece1_player_name = piece1.player[/\d/].to_i
        piece2_player_name = piece2.player[/\d/].to_i
        player_difference = (piece1_player_name - piece_2_player_name) * 13
        new_piece1_position = piece1.last_position - player_difference
        new_piece1_position += 52 if new_piece1_position < 0
        new_piece1_position -= 52 if new_piece1_position > 52
        kill_piece(piece2) if new_piece1_position == piece2.last_position
    end

    def kill_piece(piece_to_kill)
        piece_to_kill.kill_piece!
        GameCommsJob.perform_now(
            "kill_piece",
            {
                whichPlayer: piece_to_kill.player,
                whichPiece: piece_to_kill.piece
            },
            to_where: @room_channel
        )
    end

    def player_home(which_player)
        place = no_of_players_finished
        @player.user_record.add_points(POINTS[place])
        @player.user_record.check_and_raise_level
        @game.game_records.player_home!(data["whichPlayer"], PLACE[place])
        GameCommsJob.perform_now(
            "player_home",
            {
                whichPlayer: which_player
            },
            to_where: @room_channel
        )
    end

    def end_game
        @game.game_records.check_players_and_set_last
        @game.status = "FINISHED"
        @game.save
        GameCommsJob.perform_now(
            "end",
            nil,
            to_where: @room_channel
        )
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

    def next_player
        if @dice_value != 6
            nxt_player = find_next_player
            @game.update_attribute(:current_player, nxt_player)
        end
        return @game.current_player
        # GameCommsJob.perform_now(
        #     "next_player",
        #     {
        #         nextPlayer: @game.current_player
        #     },
        #     to_where: @room_channel
        # )
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

    def find_next_player
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
        player_move_records(which_player).find_by(piece: piece_name)
    end

    def player_move_records(which_player)
        @game.this_player(which_player).move_records
    end
end