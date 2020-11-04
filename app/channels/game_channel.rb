class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    stream_from "game_channel:#{params[:room]}"
    reject unless current_user.can_access_game?(params[:room])
    @game_room = Game::JoinStart.new(params[:room], player: current_user)
    @game_room.execute
  end

  def move_piece(data)
    @game_room.move_piece(data)
  end

  def next_player(data)
    @game_room.next_player(data)
  end

  def rolling(data)
    @game_room.roll_dice(data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
