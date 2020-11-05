json.code 200
json.game do
    json.extract! @game, :id, :code, :room, :scheduled_at, :join_window
end