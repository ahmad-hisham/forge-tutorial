class ForgeDerivativeController < ApplicationController


  def translate
    # Restore from session
    access_token = session[:user_access_token]

    # Initiate translate job
    ForgeDerivative.translate_item(access_token, params[:project_id], params[:item_id])

    # Detect progress until finished
    is_complete = false
    while(!is_complete)
      result = ForgeDerivative.verify_job_complete(access_token, params[:project_id], params[:item_id])
      case result[:status]
      when "pending", "inprogress"
        # "Haven't finished translating file - status: #{result[:status]}, progress: #{result[:progress]}"
        sleep 1
      when "success", "failed", "timeout"
        # "Finished translating file - status: #{result[:status]}, progress: #{result[:progress]}"
        is_complete = true
      end
    end

    # Redirect to item view with message
    flash[:info] = "Finished translating file - status: #{result[:status]}, progress: #{result[:progress]}"
    redirect_to forge_data_item_show_path(project_id: params[:project_id], item_id: params[:item_id])
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
