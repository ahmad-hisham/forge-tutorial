class ForgeDataProjectController < ApplicationController
  def index
    # Restore access_token from session
    access_token = helpers.forge_get_user_access_token()

    # Retrieve list of projects
    @projects = ForgeDataProject.get_projects(access_token, params[:hub_id])
  end


  def show
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Get project by id
    @project = ForgeDataProject.get_project(access_token, params[:hub_id], params[:id])
  end
end
