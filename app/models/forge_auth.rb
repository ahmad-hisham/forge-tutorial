require 'uri'

class ForgeAuth

  def prepare_login_url(callback_url)
    encoded_uri = URI.parse(callback_url)
    "#{API_URL}/authentication/v1/authorize?response_type=code&client_id=#{Rails.application.secrets.FORGE_CLIENT_ID}&redirect_uri=#{encoded_uri}&scope=user-profile:read%20data:read%20data:write%20data:create%20data:search%20bucket:create%20bucket:read%20bucket:update%20bucket:delete%20code:all%20account:read%20account:write"
  end

  def get_access_token_from_oauth_code(oauth_code, callback_url)
    response = RestClient.post("#{API_URL}/authentication/v1/gettoken",
                               { client_id: Rails.application.secrets.FORGE_CLIENT_ID,
                                 client_secret: Rails.application.secrets.FORGE_CLIENT_SECRET,
                                 grant_type:'authorization_code',
                                 code: oauth_code,
                                 redirect_uri: callback_url
                               })
    return JSON.parse(response.body)['access_token'], JSON.parse(response.body)['refresh_token']
  end
end
