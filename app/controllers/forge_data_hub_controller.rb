class ForgeDataHubController < ApplicationController
  def index
    # Restore access_token from session
    access_token = helpers.forge_get_user_access_token()

    # Retrieve list of Hubs
    @hubs = ForgeDataHub.get_hubs(access_token)
  end


  def show
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Get Hub by id
    @hub = ForgeDataHub.get_hub(access_token, params[:id])
  end
end
