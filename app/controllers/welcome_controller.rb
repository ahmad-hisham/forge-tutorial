class WelcomeController < ApplicationController
  def index
    forge_api = Forge.new
    response = forge_api.upload_parse_link_file
    #@text = request.base_url
    @text = response.gsub("\n", "<br/>").html_safe
  end
end
