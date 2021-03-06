require 'base64'

class ForgeDerivative
  include ActiveModel::Model

  # Translate previously uploaded file to SVF format
  def self.translate_item(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    self.translate_object(access_token, item.content_urn)
  end

  def self.translate_object(access_token, object_urn)
    base64_urn = Base64.strict_encode64(object_urn).delete("=")

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
  def self.get_job_progress(access_token, project_id, item_id)
    item = ForgeDataItem.get_item(access_token, project_id, item_id)
    self.get_job_progress_from_urn(access_token, item.content_urn)
  end

  def self.get_job_progress_from_urn(access_token, object_urn)
    base64_urn = Base64.strict_encode64(object_urn).delete("=")

    response = RestClient.get("#{API_URL}/modelderivative/v2/designdata/#{base64_urn}/manifest",
                              { Authorization: "Bearer #{access_token}"} )
    JSON.parse(response.body)
  end
end
