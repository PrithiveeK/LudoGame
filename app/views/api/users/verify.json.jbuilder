json.verified true
json.user do
    json.partial! @user, partial: 'user', as: :user
end