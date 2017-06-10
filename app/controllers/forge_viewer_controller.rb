class ForgeViewerController < ApplicationController
  def view
    # Restore from session
    access_token = session[:user_access_token]
    refresh_token = session[:user_refresh_token]

    # Redirect to viewer
    redirect_to ForgeViewer.get_viewer_link(access_token, refresh_token, params[:project_id], params[:item_id])
  end
end
