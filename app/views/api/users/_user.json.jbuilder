json.extract! @user, :id, :username, :email, :provider
json.extract! @user.user_record, :is_online, :in_game, :number_of_games, :points, :level, :avatar
json.piece @user.user_record.default_piece.name