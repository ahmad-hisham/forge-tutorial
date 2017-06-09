class ForgeDataHub
  include ActiveModel::Model

  attr_accessor :id, :name, :type, :self_link, :projects_link

  def self.get_hubs(access_token)
    response = RestClient.get("#{API_URL}/project/v1/hubs",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)["data"]

    response_json.map { |hub| self.from_json(hub) }
  end
  
  def self.get_hub(access_token, hub_id)
    # Retrieve list of Hubs
    hubs = self.get_hubs(access_token)

    # Get Hub by id
    hubs.find {|hub| hub.id == hub_id }
  end
  
  def self.from_json(hub)
    ForgeDataHub.new(
      id: hub["id"],
      name: hub["attributes"]["name"],
      type: hub["attributes"]["extension"]["type"],
      self_link: hub["links"]["self"]["href"],
      projects_link: hub["relationships"]["projects"]["links"]["related"]["href"]
    )
  end
end
