require 'base64'

class ForgeDerivative
  include ActiveModel::Model

  # Translate previously uploaded file to SVF format
  def self.translate_item(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    object_id = item.content_urn
    base_64_urn = Base64.strict_encode64(object_id)

    json_payload = %{
      {
        "input": {
          "urn": "#{base_64_urn}"
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
    JSON.parse(response.body)["result"]
  end
  
  # Poll the status of the job until it's done
  def self.verify_job_complete(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    object_id = item.content_urn
    base_64_urn = Base64.strict_encode64(object_id)

    response = RestClient.get("#{API_URL}/modelderivative/v2/designdata/#{base_64_urn}/manifest",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)

    # return hash with status and progress
    {
      status: response_json["status"],
      progress: response_json["progress"]
    }
  end

end
