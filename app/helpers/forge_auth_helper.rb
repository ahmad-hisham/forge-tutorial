module ForgeAuthHelper
  # Defined here to be available to all controllers 

  def forge_get_user_access_token
    session[:user_access_token]
  end

  def forge_get_app_access_token
    session[:app_access_token]
  end

  def forge_set_app_access_token(app_access_token)
    session[:app_access_token] = app_access_token
  end

  def forge_set_user_access_token(access_token)
    session[:user_access_token] = access_token
  end

  def forge_set_user_refresh_token(refresh_token)
    session[:user_refresh_token] = refresh_token
  end
end
