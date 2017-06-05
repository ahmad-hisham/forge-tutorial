require 'uri'

class ForgeAuth

  def prepare_login_url(callback_url)
    encoded_uri = URI.parse(callback_url)
    "#{API_URL}/authentication/v1/authorize?response_type=code&client_id=#{Rails.application.secrets.FORGE_CLIENT_ID}&redirect_uri=#{encoded_uri}&scope=data:read"
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
