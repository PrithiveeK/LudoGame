json.code 200
json.games do
    json.array!(@games) do |game|
        json.extract! game, :id, :room, :scheduled_at, :status, :code
        json.players do
            json.array! game.game_records.map {|record| record.player.username}
        end
    end
end