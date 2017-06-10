class ForgeDataBucketController < ApplicationController
  def index
    # Restore access_token from session or get access_token and save in session
    app_access_token = session[:app_access_token] || ForgeAuth.get_app_access_token
    session[:app_access_token] = app_access_token

    p "app_access_token", app_access_token
    
    # Retrieve list of Buckets
    @buckets = ForgeDataBucket.get_buckets(app_access_token)
  end


  def show
    # Restore access_token from session or get access_token and save in session
    app_access_token = session[:app_access_token] || ForgeAuth.get_app_access_token
    session[:app_access_token] = app_access_token

    # Get Bucket by id
    @bucket = ForgeDataBucket.get_bucket(app_access_token, params[:id])
  end


  def new
    # Restore access_token from session or get access_token and save in session
    app_access_token = session[:app_access_token] || ForgeAuth.get_app_access_token
    session[:app_access_token] = app_access_token

    # Create new bucket
    ForgeDataBucket.new_bucket(app_access_token, params[:name])

    # Show buckets with new bucket
    flash[:info] = "Bucket created Successfully"
    redirect_to forge_data_buckets_path
  end
end
