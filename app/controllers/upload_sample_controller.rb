class UploadSampleController < ApplicationController
  def run
    forge_upload_sample_api = ForgeUploadSample.new
    response = forge_upload_sample_api.upload_parse_link_file
    @text = response.gsub("\n", "<br/>").html_safe
  end
end
