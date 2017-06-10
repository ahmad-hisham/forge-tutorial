class ForgeDataBucket
  include ActiveModel::Model

  attr_accessor :id, :created_date, :policy_key

  def self.get_buckets(access_token)
    response = RestClient.get("#{API_URL}/oss/v2/buckets",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)["items"]

    response_json.map { |bucket| self.from_json(bucket) }
  end
  
  def self.get_bucket(access_token, bucket_id)
    response = RestClient.get("#{API_URL}/oss/v2/buckets?bucketKey=#{bucket_id}",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)["items"]

    self.from_json(response_json[0])
  end
  
  def self.from_json(bucket)
    ForgeDataBucket.new(
      id: bucket["bucketKey"],
      created_date: Time.strptime(bucket["createdDate"].to_s,'%Q').to_datetime,
      policy_key: bucket["policyKey"]
    )
  end
end
