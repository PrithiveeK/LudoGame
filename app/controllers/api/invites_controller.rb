class Api::InvitesController < ApplicationController
    load_and_authorize_resource class: 'Invite', only: [:index]

    def index
        # Hope cancancan will takecare of it
    end

    def now
        @invite = Invite.last
    end

end
