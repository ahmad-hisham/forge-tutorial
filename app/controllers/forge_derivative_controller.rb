class ForgeDerivativeController < ApplicationController


  def translate
    # Restore from session
    access_token = session[:user_access_token]

    # Initiate translate job
    result = ForgeDerivative.translate_item(access_token, params[:project_id], params[:item_id])

    # Detect progress until finished
    Timeout::timeout(120) do # 2 min
      loop do
        result = ForgeDerivative.get_job_progress(access_token, params[:project_id], params[:item_id])
        p "Translate file to SVF - status: #{result['status']}, progress: #{result['progress']}"
  
        break if result["progress"] == "complete" or ["success", "failed", "timeout"].include? result["status"]
        sleep 1 # if ["pending", "inprogress"].include? result["status"]
      end
    end

    # Redirect to item view with message
    flash[:info] = "Finished translating file - status: #{result["status"]}, progress: #{result["progress"]}"
    redirect_to forge_data_item_show_path(project_id: params[:project_id], item_id: params[:item_id])
  end


  def translate_object
    # Restore from session
    access_token = session[:app_access_token]

    # Construct object_id from passed parameters
    object_id = params[:object_id] || "urn:adsk.objects:os.object:#{params[:bucket_id]}/#{params[:object_name]}"

    # Initiate translate job
    result = ForgeDerivative.translate_object(access_token, object_id)

    # Detect progress until finished
    Timeout::timeout(120) do # 2 min
      loop do
        result = ForgeDerivative.get_job_progress_from_urn(access_token, object_id)
        p "Translate file to SVF - status: #{result['status']}, progress: #{result['progress']}"
  
        break if result["progress"] == "complete" or ["success", "failed", "timeout"].include? result["status"]
        sleep 1 # if ["pending", "inprogress"].include? result["status"]
      end
    end

    # Redirect to item view with message
    flash[:info] = "Finished translating file - status: #{result["status"]}, progress: #{result["progress"]}"
    redirect_to forge_data_object_show_path(bucket_id: params[:bucket_id], object_name: params[:object_name])
  end


  def translate_start
    # Restore from session
    access_token = session[:user_access_token]

    # Initiate translate job
    @result = ForgeDerivative.translate_item(access_token, params[:project_id], params[:item_id])
  end


  def translate_progress
    # Restore from session
    access_token = session[:user_access_token]

    # Initiate translate job
    @result = ForgeDerivative.verify_job_complete(access_token, params[:project_id], params[:item_id])
  end
end
