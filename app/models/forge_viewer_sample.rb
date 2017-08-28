class ForgeViewerSample

  BUCKET_KEY = "forge-rails-tutorial-app-#{Rails.application.secrets.FORGE_CLIENT_ID.downcase}"
  FILE_NAME = 'sample_dwg.dwg' # 'elephant.obj' #
  FILE_PATH = "#{Rails.public_path}/#{FILE_NAME}" 

  def self.get_sample_object
    # Get access token
    access_token = ForgeAuth.get_app_access_token

    # Get object using bucket and object name
    begin
      ForgeDataObject.get_object(access_token, BUCKET_KEY, FILE_NAME)
    rescue
      return nil
    end
  end

  def self.upload_and_translate_sample_object
    ### 1. Get access token
    access_token = ForgeAuth.get_app_access_token

    ### 2. Create bucket
    ForgeDataBucket.new_bucket(access_token, BUCKET_KEY)

    ### 3. Upload file
    uploaded_object = ForgeDataObject.upload_object(access_token, BUCKET_KEY, FILE_PATH, FILE_NAME)
    object_urn = uploaded_object.id

    ### 4. Translate to svf
    translate_job_response = ForgeDerivative.translate_object(access_token, object_urn)
    p translate_job_response #["result"]

    ### 5. Translate to svf complete
    Timeout::timeout(120) do # 2 min
      loop do
        verify_response = ForgeDerivative.get_job_progress_from_urn(access_token, object_urn)
        p "Translate file to SVF - status: #{verify_response['status']}, progress: #{verify_response['progress']}"
  
        break if verify_response["progress"]=="complete"
        sleep 1
      end
    end
    
    return uploaded_object
  end
end