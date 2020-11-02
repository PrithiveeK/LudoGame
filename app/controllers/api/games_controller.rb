class Api::GamesController < ApplicationController
    def create
        @curr_user = current_user
        result = Game::CreateInvitation.call(game_params, created_by: @curr_user)
        render json: {done: result}
    end

    private
    
    def game_params
        params.require(:game).permit(:player1_id, :player2_id, :player3_id, :player4_id, :room_name, :scheduled_at, :join_window)
    end
end
