class ForgeAuthController < ApplicationController

  # Set a link to login to Autodesk account
  def login
    my_forge_auth = ForgeAuth.new
    # callback_url is created from current base_url and the callback action path
    callback_url = request.base_url + forge_auth_callback_path
    @login_url = my_forge_auth.prepare_login_url(callback_url)
  end

  # Receive successful login details and save access_token 
  def callback
    callback_code = params[:code]
    callback_url = request.base_url + forge_auth_callback_path 
    
    # Get access_token & refresh_token from oauth_code received from url params
    my_forge_auth = ForgeAuth.new
    access_token,refresh_token = my_forge_auth.get_access_token_from_oauth_code(callback_code,callback_url)

    # Save to session
    session[:user_access_token] = access_token
    session[:user_refresh_token] = refresh_token
  
    # Redirect to next page
    #redirect_to forge_data_hubs_path
    @result = "access_token: #{access_token} || refresh_token: #{refresh_token}"
  end
end
