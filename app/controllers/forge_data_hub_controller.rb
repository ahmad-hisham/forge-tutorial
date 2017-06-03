class ForgeDataHubController < ApplicationController
  def index
    # Restore access_token from session
    access_token = session[:user_access_token]
    refresh_token = session[:user_refresh_token]

    #DEBUG: Show access_token
    p "access_token: #{access_token} || refresh_token: #{refresh_token}"
    
    # Retrieve list of Hubs
    @hubs = ForgeDataHub.get_hubs(access_token)
  end


  def show
    # Restore from session
    access_token = session[:user_access_token]

    # Get Hub by id
    @hub = ForgeDataHub.get_hub(access_token, params[:id])
  end
end
