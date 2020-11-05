class Api::GamesController < ApplicationController

    def create
        @curr_user = current_user
        result = Game::CreateGame.call(game_params, created_by: @curr_user.id)
        if result
            render json: {done: true, code: result}
        else
            render json: {done: false}
        end
    end

    def invites
        @invites = Game.find_invites(current_user.id)
        render :invites
    end

    def now
        @game = current_user.find_next_game(DateTime.now)
        if @game
            render :games
        else
            render json: {code: 404, message: "No games at the moment"}
        end
    end

    private
    
    def game_params
        params.require(:game).permit(:player1_id, :player2_id, :player3_id, :player4_id, :room_name, :scheduled_at, :join_window)
    end
end
