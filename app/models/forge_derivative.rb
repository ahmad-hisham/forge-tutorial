require 'base64'

class ForgeDerivative
  include ActiveModel::Model

  # Translate previously uploaded file to SVF format
  def self.translate_item(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    base64_urn = Base64.strict_encode64(item.content_urn).delete("=")

    json_payload = %{
      {
        "input": {
          "urn": "#{base64_urn}"
        },
        "output": {
          "formats": [
            {
              "type": "svf",
              "views": [ "2d","3d" ]
            }
          ]
        }
      }
    }

    response = RestClient.post("#{API_URL}/modelderivative/v2/designdata/job",
                               json_payload,
                               { Authorization: "Bearer #{access_token}", content_type:'application/json' })
    JSON.parse(response.body)
  end
  
  # Poll the status of the job until it's done
  def self.verify_job_complete(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    base64_urn = Base64.strict_encode64(item.content_urn).delete("=")

    response = RestClient.get("#{API_URL}/modelderivative/v2/designdata/#{base64_urn}/manifest",
                              { Authorization: "Bearer #{access_token}"} )
    JSON.parse(response.body)
  end
end
