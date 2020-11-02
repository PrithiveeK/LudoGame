json.code 200
json.users do
    json.array!(@all_users) do |user|
        json.extract! user, :id, :username, :email
        json.extract! user.user_record, :is_online, :in_game, :number_of_games, :points, :level, :avatar
    end
end
