json.code 200
json.records do
    json.array!(@user_stats) do |stat|
        json.room stat.game.room
        json.place stat.place
    end
end