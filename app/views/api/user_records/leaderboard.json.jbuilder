json.code 200
json.records do
    json.array!(@user_records) do |ur|
        json.username ur.user.username
        json.points ur.points
    end
end