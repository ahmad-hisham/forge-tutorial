class UploadSampleController < ApplicationController
  def run
    forge_api = Forge.new
    response = forge_api.upload_parse_link_file
    @text = response.gsub("\n", "<br/>").html_safe
  end
end
