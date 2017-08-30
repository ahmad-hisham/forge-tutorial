class ForgeDataObjectController < ApplicationController
  def index
    # Restore access_token from session
    app_access_token = helpers.forge_get_app_access_token()

    # Retrieve list of Objects
    @objects = ForgeDataObject.get_objects(app_access_token, params[:bucket_id])
  end


  def show
    # Restore access_token from session
    app_access_token = helpers.forge_get_app_access_token()

    # Get Object by id
    @object = ForgeDataObject.get_object(app_access_token, params[:bucket_id], params[:object_name])
  end


  def upload
    # Restore access_token from session
    app_access_token = helpers.forge_get_app_access_token()

    # Upload sample object
    # NOTE: Fixed file to minimize OSS access abuse
    object_name = 'elephant.obj'
    file_location = "#{Rails.public_path}/#{object_name}"
    ForgeDataObject.upload_object(app_access_token, params[:bucket_id], file_location, object_name)

    # Show bucket with new object
    flash[:info] = "Object uploaded Successfully"
    redirect_to forge_data_objects_path
  end
end
