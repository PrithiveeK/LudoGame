class Api::InvitesController < ApplicationController
    load_and_authorize_resource

    def index
        # Hope cancancan will takecare of it
    end

end
