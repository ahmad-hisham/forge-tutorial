class ForgeViewerController < ApplicationController
  def view
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Redirect to viewer
    redirect_to ForgeViewer.get_viewer_link(access_token, params[:project_id], params[:item_id])
  end


  def view_object
    # Restore from session
    access_token = helpers.forge_get_app_access_token()

    # Construct object_id from passed parameters
    object_id = params[:object_id] || "urn:adsk.objects:os.object:#{params[:bucket_id]}/#{params[:object_name]}"

    # Redirect to viewer
    redirect_to ForgeViewer.get_viewer_link_from_object(access_token, object_id)
  end
end
