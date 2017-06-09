require 'uri'

class ForgeAuth

  def self.prepare_login_url(callback_url, scopes = "all")
    if scopes == "all"
      scopes = "user-profile:read%20data:read%20data:write%20data:create%20data:search%20bucket:create%20bucket:read%20bucket:update%20bucket:delete%20code:all%20account:read%20account:write"
    end

    encoded_uri = URI.parse(callback_url)
    "#{API_URL}/authentication/v1/authorize?response_type=code&client_id=#{Rails.application.secrets.FORGE_CLIENT_ID}&redirect_uri=#{encoded_uri}&scope=#{scopes}"
  end

  def self.get_access_token_from_oauth_code(oauth_code, callback_url)
    response = RestClient.post("#{API_URL}/authentication/v1/gettoken",
                               { client_id: Rails.application.secrets.FORGE_CLIENT_ID,
                                 client_secret: Rails.application.secrets.FORGE_CLIENT_SECRET,
                                 grant_type:'authorization_code',
                                 code: oauth_code,
                                 redirect_uri: callback_url
                               })
    return JSON.parse(response.body)['access_token'], JSON.parse(response.body)['refresh_token']
  end
  
  def self.refresh_access_token(refresh_token, scopes = "all")
    if scopes == "all"
      scopes = "user-profile:read%20data:read%20data:write%20data:create%20data:search%20bucket:create%20bucket:read%20bucket:update%20bucket:delete%20code:all%20account:read%20account:write"
    end
    response = RestClient.post("#{API_URL}/authentication/v1/refreshtoken",
                               { client_id: Rails.application.secrets.FORGE_CLIENT_ID,
                                 client_secret: Rails.application.secrets.FORGE_CLIENT_SECRET,
                                 grant_type:'refresh_token',
                                 refresh_token: refresh_token,
                                 scope: scopes
                               })
    return JSON.parse(response.body)['access_token'], JSON.parse(response.body)['refresh_token']
  end
end
