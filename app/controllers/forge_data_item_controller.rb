class ForgeDataItemController < ApplicationController
  def index
    # Restore access_token from session
    access_token = helpers.forge_get_user_access_token()

    # Retrieve list of items
    @items = ForgeDataItem.get_items(access_token, params[:project_id], params[:folder_id])
  end


  def show_folder
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Get item by id
    @item = ForgeDataItem.get_folder(access_token, params[:project_id], params[:folder_id])
  end


  def show_item
    # Restore from session
    @access_token = helpers.forge_get_user_access_token()

    # Get item by id
    @item = ForgeDataItem.get_item(@access_token, params[:project_id], params[:item_id])
  end


  def upload
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Receive uploaded file and save to temporary location
    uploaded_io = params[:uploaded_file]
    file_name = uploaded_io.original_filename
    file_location = Rails.root.join('tmp', 'uploads', file_name)

    File.open(file_location, 'wb') do |file|
      file.write(uploaded_io.read)
    end

    # Upload file to selected folder
    @item = ForgeDataItem.upload_to_folder(access_token, params[:project_id], params[:folder_id], file_location, file_name)

    # Redirect to folder view with new item
    flash[:info] = "Item Uploaded Successfully"
    redirect_to @item
  end


  def new_folder
    # Restore from session
    access_token = helpers.forge_get_user_access_token()

    # Create new folder in selected folder
    @item = ForgeDataItem.new_folder(access_token, params[:project_id], params[:folder_id], params[:subfolder_name])

    # Redirect to folder view with new item
    flash[:info] = "Folder created Successfully"
    redirect_to @item
  end
end
