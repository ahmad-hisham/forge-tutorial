class ViewerSampleController < ApplicationController
  def index
    app_access_token = ForgeAuth.get_app_access_token
    helpers.forge_set_app_access_token(app_access_token)

    @uploaded_object = ForgeViewerSample.get_sample_object
  end

  def run
    @uploaded_object = ForgeViewerSample.upload_and_translate_sample_object
    flash[:info] = "Item Uploaded Successfully"
    redirect_to viewer_sample_path
  end
end
