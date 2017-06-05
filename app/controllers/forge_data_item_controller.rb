class ForgeDataItemController < ApplicationController
  def index
    # Restore access_token from session
    access_token = session[:user_access_token]

    # Retrieve list of items
    @items = ForgeDataItem.get_items(access_token, params[:project_id], params[:folder_id])
  end


  def show_folder
    # Restore from session
    access_token = session[:user_access_token]

    # Get item by id
    @item = ForgeDataItem.get_folder(access_token, params[:project_id], params[:folder_id])
  end


  def show_item
    # Restore from session
    @access_token = session[:user_access_token]

    # Get item by id
    @item = ForgeDataItem.get_item(@access_token, params[:project_id], params[:item_id])
  end
end
