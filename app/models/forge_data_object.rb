class ForgeDataObject
  include ActiveModel::Model

  attr_accessor :id, :name, :bucket_id, :sha1, :size, :location

  def self.get_objects(access_token, bucket_id)
    response = RestClient.get("#{API_URL}/oss/v2/buckets/#{bucket_id}/objects",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)["items"]

    response_json.map { |object| self.from_json(object) }
  end
  
  def self.get_object(access_token, bucket_id, object_name)
    response = RestClient.get("#{API_URL}/oss/v2/buckets/#{bucket_id}/objects/#{object_name}/details",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)

    self.from_json(response_json)
  end

  def self.upload_object(access_token, bucket_id, file_location, object_name)
    file_uploaded = File.new(file_location, 'rb')
    response = RestClient.put("#{API_URL}/oss/v2/buckets/#{bucket_id}/objects/#{object_name}",
                               file_uploaded,
                               { Authorization: "Bearer #{access_token}", content_type:'application/octet-stream'})
    return response
    #self.from_json(response)
  end

  def self.from_json(object)
    ForgeDataObject.new(
      id: object["objectId"],
      name: object["objectKey"],
      bucket_id: object["bucketKey"],
      sha1: object["sha1"],
      size: object["size"],
      location: object["location"]
    )
  end
end