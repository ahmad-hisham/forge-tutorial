class ForgeDataProject
  include ActiveModel::Model

  attr_accessor :id, :name, :type, :hub_id, :self_link, :root_folder_urn, :top_folders_link

  def self.get_projects(access_token, hub_id)
    response = RestClient.get("#{API_URL}/project/v1/hubs/#{hub_id}/projects",
                              { Authorization: "Bearer #{access_token}"} )
    response_json = JSON.parse(response.body)["data"]

    response_json.map { |project|
      ForgeDataProject.new(
        id: project["id"],
        name: project["attributes"]["name"],
        type: project["attributes"]["extension"]["type"],
        hub_id: hub_id,
        self_link: project["links"]["self"]["href"],
        root_folder_urn: project["relationships"]["rootFolder"]["data"]["id"],
        top_folders_link: project["relationships"]["topFolders"]["links"]["related"]["href"]
      )
    }
  end
  
  def self.get_project(access_token, hub_id, project_id)
    #response = RestClient.get("#{API_URL}/project/v1/hubs/#{hub_id}/projects?filter%5Bid%5D=#{project_id}",
    #                          { Authorization: "Bearer #{access_token}"} )
    #response_json = JSON.parse(response.body)["data"]

    # Retrieve list of Projects
    projects = self.get_projects(access_token, hub_id)

    # Get Project by id
    projects.find {|project| project.id == project_id }
  end
end
