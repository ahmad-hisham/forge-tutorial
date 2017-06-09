class ForgeDataItem
  include ActiveModel::Model

  attr_accessor :id, :name, :name_internal, :type, :project_id,
                :create_time, :create_user_id, :create_user_name,
                :last_modified_time, :last_modified_user_id, :last_modified_user_name,
                :object_count, :hidden, :self_link, :parent_link,
                :name_internal, :version_number, :mime_type, :file_type, :storage_size,# item_only_attr
                :derivatives_link, :thumbnails_link, :content_link, :content_urn

  def self.get_items(access_token, project_id, folder_id)
    response = RestClient.get("#{API_URL}/data/v1/projects/#{project_id}/folders/#{folder_id}/contents",
                              { Authorization: "Bearer #{access_token}"} )

    response_json = JSON.parse(response.body)["data"]
    response_json.map { |item| self.from_json(item, project_id) }
  end

  def self.get_folder(access_token, project_id, folder_id)
    response = RestClient.get("#{API_URL}/data/v1/projects/#{project_id}/folders/#{folder_id}",
                              { Authorization: "Bearer #{access_token}"} )

    response_json = JSON.parse(response.body)["data"]
    self.from_json(response_json, project_id)
  end

  def self.get_item(access_token, project_id, item_id)
    response = RestClient.get("#{API_URL}/data/v1/projects/#{project_id}/items/#{item_id}",
                              { Authorization: "Bearer #{access_token}"} )

    response_json = JSON.parse(response.body)
    self.from_json_with_item_details(response_json, project_id)
  end

  def self.upload_to_folder(access_token, project_id, folder_id, file_location, file_name)
    #--- Prepare a storage location for specified folder/project
    json_payload_storage = %{
      {
        "jsonapi": { "version": "1.0" },
        "data": {
          "type": "objects",
          "attributes": {
            "name": "#{file_name}"
          },
          "relationships": {
            "target": {
              "data": { "type": "folders", "id": "#{folder_id}" }
            }
          }
        }
      }
    }
    response = RestClient.post("#{API_URL}/data/v1/projects/#{project_id}/storage",
                               json_payload_storage,
                               {
                                  Authorization: "Bearer #{access_token}",
                                  content_type:"application/vnd.api+json",
                                  Accept: "application/vnd.api+json"
                                })
    
    #--- Get bucket_id and file_name
    upload_object_id = JSON.parse(response.body)["data"]["id"]
    upload_bucket_id = upload_object_id.split('/')[0].sub("urn:adsk.objects:os.object:", "")
    upload_file_name = upload_object_id.split('/')[1]
    p "##Storage created",upload_object_id,json_payload_storage

    #--- Upload file to desigenated storage location
    file_to_upload = File.new(file_location, 'rb')
    p "#{API_URL}/oss/v2/buckets/#{upload_bucket_id}/objects/#{upload_file_name}"
    p access_token
    begin
    upload_response = RestClient.put("#{API_URL}/oss/v2/buckets/#{upload_bucket_id}/objects/#{upload_file_name}",
                                     file_to_upload,
                                     { Authorization: "Bearer #{access_token}", content_type:"application/octet-stream"})
    file_urn = JSON.parse(upload_response.body)['objectId']
    #rescue RestClient::Exception => e
    #  p "Error: Caught exception #{e.message}! #{e.response}"
    end

    p "##File uploaded",file_urn

    #--- Link uploaded file to versioned item in selected folder/project
    json_payload_versions = %{
      {
        "jsonapi": { "version": "1.0" },
        "data": {
          "type": "items",
          "attributes": {
            "displayName": "#{file_name}",
            "extension": {
              "type": "items:autodesk.core:File",
              "version": "1.0"
            }
          },
          "relationships": {
            "tip": {
              "data": {
                "type": "versions", "id": "1"
              }
            },
            "parent": {
              "data": {
                "type": "folders",
                "id": "#{folder_id}"
              }
            }
          }
        },
        "included": [
          {
            "type": "versions",
            "id": "1",
            "attributes": {
              "name": "#{file_name}",
              "extension": {
                "type": "versions:autodesk.core:File",
                "version": "1.0"
              }
            },
            "relationships": {
              "storage": {
                "data": {
                  "type": "objects",
                  "id": "#{file_urn}"
                }
              }
            }
          }
        ]
      }
    }
    p "PAYLOAD:",json_payload_versions
    response_versions = RestClient.post("#{API_URL}/data/v1/projects/#{project_id}/items",
                                        json_payload_versions,
                                        {
                                          Authorization: "Bearer #{access_token}",
                                          content_type:"application/vnd.api+json",
                                          Accept: "application/vnd.api+json"
                                         })

    response_versions_json = JSON.parse(response_versions.body)
    p "RESPONSE:",response_versions_json
    self.from_json_with_item_details(response_versions_json, project_id)
  end

  def self.from_json(json_item, project_id)
    ForgeDataItem.new(
      id:                       json_item["id"],
      name:                     json_item["attributes"]["displayName"],
      name_internal:            json_item["attributes"]["name"],
      type:                     json_item["type"], # "folders" or "items"
      project_id:               project_id,
      create_time:              json_item["attributes"]["createTime"].to_datetime,
      create_user_id:           json_item["attributes"]["createUserId"],
      create_user_name:         json_item["attributes"]["createUserName"],
      last_modified_time:       json_item["attributes"]["lastModifiedTime"].to_datetime,
      last_modified_user_id:    json_item["attributes"]["lastModifiedUserId"],
      last_modified_user_name:  json_item["attributes"]["lastModifiedUserName"],
      object_count:             json_item["attributes"]["objectCount"],
      hidden:                   json_item["attributes"]["hidden"],
      #type:                    json_item["attributes"]["extension"]["type"],
      self_link:                json_item["links"]["self"]["href"],
      parent_link:              json_item["relationships"]["parent"]["data"]["id"]
    )
  end

  def self.from_json_with_item_details(json_item, project_id)
    item = self.from_json(json_item["data"], project_id)
    json_included = json_item["included"].first
    item.name_internal =    json_included["attributes"]["displayName"]
    item.version_number =   json_included["attributes"]["versionNumber"]
    item.mime_type =        json_included["attributes"]["mimeType"]
    item.file_type =        json_included["attributes"]["fileType"]
    item.storage_size =     json_included["attributes"]["storageSize"]
    item.derivatives_link = json_included["relationships"]["derivatives"]["meta"]["link"]["href"] unless json_included["relationships"]["derivatives"].nil?
    item.thumbnails_link =  json_included["relationships"]["thumbnails"]["meta"]["link"]["href"] unless json_included["relationships"]["thumbnails"].nil?
    item.content_link =     json_included["relationships"]["storage"]["meta"]["link"]["href"] unless json_included["relationships"]["storage"].nil?
    item.content_urn =      json_included["relationships"]["storage"]["data"]["id"] unless json_included["relationships"]["storage"].nil?
    item
  end
end
