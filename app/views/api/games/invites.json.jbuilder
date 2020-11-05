json.code 200
json.invites do
    json.array!(@invites) do |invite|
        json.extract! invite, :id, :room, :scheduled_at, :status
        json.players do
            json.array! invite.game_records.map {|record| record.player.username}
        end
    end
end