class User::FromOauth
    def self.create(access_token)
        graph = Koala::Facebook::API.new(access_token)
        @profile = graph.get_object('me', fields: ['name', 'email'])
        if user = User.find_by(uid: @profile['id'])
            user
        else
            return nil if User.find_by(email: @profile['email'])
            new_user = User.create(user_params)
            UserRecord.create(user_id: new_user.id) 
            new_user
        end
    end

    private

    def self.user_params
        {
            username: @profile['name'],
            email: @profile['email'],
            uid: @profile['id'],
            provider: 'facebook',
            password: 'my_oauth_password',
            password_confirmation: 'my_oauth_password'
        }
    end
end