class UploadSampleController < ApplicationController
  def run
    forge_sample_api = ForgeSample.new
    response = forge_sample_api.upload_parse_link_file
    @text = response.gsub("\n", "<br/>").html_safe
  end
end
