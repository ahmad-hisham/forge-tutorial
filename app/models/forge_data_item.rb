class ForgeDataItem
  include ActiveModel::Model

  attr_accessor :id, :name, :name_internal, :type, :project_id,
                :create_time, :create_user_id, :create_user_name,
                :last_modified_time, :last_modified_user_id, :last_modified_user_name,
                :object_count, :hidden, :self_link, :parent_link,
                :name_internal, :version_number, :mime_type, :file_type, :storage_size,# item_only_attr
                :derivatives_link, :thumbnails_link, :content_link

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
    self.from_json_with_item_details(response_json, project_id, access_token)
  end

  def self.from_json(json_item, project_id)
    ForgeDataItem.new(
      id:                       json_item["id"],
      name:                     json_item["attributes"]["displayName"],
      name_internal:            json_item["attributes"]["name"],
      type:                     json_item["type"], # "folders" or "items"
      project_id:               project_id,
      create_time:              json_item["attributes"]["createTime"],
      create_user_id:           json_item["attributes"]["createUserId"],
      create_user_name:         json_item["attributes"]["createUserName"],
      last_modified_time:       json_item["attributes"]["lastModifiedTime"],
      last_modified_user_id:    json_item["attributes"]["lastModifiedUserId"],
      last_modified_user_name:  json_item["attributes"]["lastModifiedUserName"],
      object_count:             json_item["attributes"]["objectCount"],
      hidden:                   json_item["attributes"]["hidden"],
      #type:                    json_item["attributes"]["extension"]["type"],
      self_link:                json_item["links"]["self"]["href"],
      parent_link:              json_item["relationships"]["parent"]["data"]["id"]
    )
  end

  def self.from_json_with_item_details(json_item, project_id, access_token)
    item = self.from_json(json_item["data"], project_id)
    json_included = json_item["included"].first
    item.name_internal =    json_included["attributes"]["displayName"]
    item.version_number =   json_included["attributes"]["versionNumber"]
    item.mime_type =        json_included["attributes"]["mimeType"]
    item.file_type =        json_included["attributes"]["fileType"]
    item.storage_size =     json_included["attributes"]["storageSize"]
    item.derivatives_link = json_included["relationships"]["derivatives"]["meta"]["link"]["href"] unless json_included["relationships"]["derivatives"].nil?
    item.thumbnails_link =  json_included["relationships"]["thumbnails"]["meta"]["link"]["href"] unless json_included["relationships"]["thumbnails"].nil?
    item.content_link  =    json_included["relationships"]["storage"]["meta"]["link"]["href"] unless json_included["relationships"]["storage"].nil?
    # or included.relationships.storage.data.id
    return item
  end
end
