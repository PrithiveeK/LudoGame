json.code 200
json.invites do
    json.array!(@invites) do |invite|
        json.extract! invite, :id, :game_id
        json.extract! invite.game, :room, :scheduled_at
        json.player1 invite.game.player1.username
        json.player2 invite.game.player2.username
        json.player3 invite.game.player3.username unless invite.game.player3
        json.player4 invite.game.player4.username unless invite.game.player3
    end
end