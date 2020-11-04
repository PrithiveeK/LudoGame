json.code 200
json.invite do
    json.extract! @invite, :id, :code
    json.extract! @invite.game, :room, :scheduled_at, :join_window
    json.created_by @invite.created_by.username
end