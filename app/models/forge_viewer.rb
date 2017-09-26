require 'base64'

class ForgeViewer
  # Construct the url of the viewer
  def self.get_viewer_link(access_token, project_id, item_id, viewer_id = 1)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    # Encode urn in Base64, strip padding
    # BUG: Viewer doesn't recognize the urn if not uploaded from App and no prior translation job has been initiated
    #      Use base64_urn already embedded in derivatives_link
    #base64_urn = Base64.strict_encode64(item.content_urn).delete("=")
    base64_urn = item.derivatives_link
                  .sub("#{API_URL}/modelderivative/v2/designdata/","")
                  .sub("/manifest","")

    # Get data:read scoped access_token for viewer
    read_only_access_token = access_token
    #ToDo: Fix HTTP 400 Error The authorization code/refresh token is expired or invalid/redirect_uri must have the same value as in the authorization request.
    #begin
    #  read_only_access_token,new_refresh_token=ForgeAuth.refresh_access_token(refresh_token, "data:read")
    #rescue RestClient::Exception => e
    #  p "Error: Caught exception #{e.message}! #{e.response}"
    #end

    # Return viewer url
    "/viewer#{viewer_id}.html?token=#{read_only_access_token}&urn=#{base64_urn}"
  end

  # Construct the url of the viewer
  def self.get_viewer_link_from_object(access_token, object_id, viewer_id = 1)
    # Encode urn in Base64, strip padding
    base64_urn = Base64.strict_encode64(object_id).delete("=")
    
    # Return viewer url
    "/viewer#{viewer_id}.html?token=#{access_token}&urn=#{base64_urn}"
  end
end
