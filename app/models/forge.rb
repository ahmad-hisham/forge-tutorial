require 'rest-client'
require 'json'
require 'base64'
require 'open-uri'

class Forge

  API_URL = 'https://developer.api.autodesk.com'
  BUCKET_KEY = "forge-rails-tutorial-app-#{Rails.application.secrets.FORGE_CLIENT_ID.downcase}"
  FILE_NAME = 'elephant.obj' 
  FILE_PATH = "#{Rails.public_path}/#{FILE_NAME}" 

  def initialize()
  end

  def upload_parse_link_file
    log = "Running Forge API\n"
   
    begin
      log += "***** 1. Got access token\n"
      access_token = get_access_token
      log += "Token: #{access_token[0..20]}...\n"

      begin
        log += "***** 2. Create bucket\n"
        create_bucket_response = create_bucket(BUCKET_KEY, access_token)
        log += "Response: #{create_bucket_response}\n"
      rescue RestClient::Exception => e
        log += "Error: #{e.response}\n"
      end
    
      log += "***** 3. Upload file\n"
      upload_response = upload_file(BUCKET_KEY,FILE_PATH,FILE_NAME,access_token)
      #log += "Response: #{upload_response}\n"
      urn = JSON.parse(upload_response.body)['objectId']
      log += "URN: #{urn}\n"
    
      log += "***** 4. Translate to svf\n"
      translate_job_response = translate_to_svf(urn,access_token)
      log += "Response: #{JSON.parse(translate_job_response.body)["result"]}\n"

      log += "***** 5. Translate to svf complete\n"
      urn_encoded = JSON.parse(translate_job_response.body)["urn"]
      verify_response = verify_job_complete(urn_encoded,access_token)
      log += "Response: #{JSON.parse(verify_response.body)["status"]}\n"

      log += "***** 6. Generate Viewer link\n"
      if(JSON.parse(verify_response.body)["status"]=='success')
        link = get_viewer_link(urn_encoded,access_token)
        log += link
      end

    rescue RestClient::Exception => e
      log += "Error: Caught exception #{e.message}! #{e.response} #{e.backtrace}\n"

    ensure
      return log
    end
  end

  # 2 Legged Authentication in Forge - returns the access token
  def get_access_token
    response = RestClient.post("#{API_URL}/authentication/v1/authenticate",
                               { client_id: Rails.application.secrets.FORGE_CLIENT_ID,
                                 client_secret: Rails.application.secrets.FORGE_CLIENT_SECRET,
                                 grant_type:'client_credentials',scope:'data:read data:write bucket:create'
                                 
                               })
    return JSON.parse(response.body)['access_token']
  end

  # Create a new bucket in Forge API.
  def create_bucket(bucket_key, access_token)
    begin
      response = RestClient.post("#{API_URL}/oss/v2/buckets",
                                 { bucketKey: bucket_key, policyKey:'transient'}.to_json,
                                 { Authorization: "Bearer #{access_token}", content_type:'application/json' })
      return response
    rescue RestClient::Exception => e
      if e.response.code == 409
        then return 'Bucket already exists'
        else raise e
      end
    end
  end
  
  # Upload a file to a previously created bucket
  def upload_file(bucket_key, file_location, file_name, access_token)
    file_uploaded = File.new(file_location, 'rb')
    response = RestClient.put("#{API_URL}/oss/v2/buckets/#{bucket_key}/objects/#{file_name}",
                               file_uploaded,
                               { Authorization: "Bearer #{access_token}", content_type:'application/octet-stream'})
    return response
  end
  
  # Translate previously uploaded file to SVF format
  def translate_to_svf(object_id, access_token)
    base_64_urn = Base64.strict_encode64(object_id)
    response = RestClient.post("#{API_URL}/modelderivative/v2/designdata/job",
                               {
                                   input: {
                                       urn: base_64_urn
                                   },
                                   output: {
                                       formats: [
                                           {
                                               type: "svf",
                                               views: [
                                                   "3d"
                                               ]
                                           }
                                       ]
                                   }
                               }.to_json,
                               { Authorization: "Bearer #{access_token}", content_type:'application/json' })
    return response
  end
  
  # Poll the status of the job until it's done
  def verify_job_complete(base_64_urn,access_token)
    is_complete = false
  
    while(!is_complete)
      response = RestClient.get("#{API_URL}/modelderivative/v2/designdata/#{base_64_urn}/manifest",
                                { Authorization: "Bearer #{access_token}"} )
      json = JSON.parse(response.body)
      if(json["progress"]=="complete")
        is_complete = true
        p "Finished translating your file to SVF - status: #{json['status']}, progress: #{json['progress']} "
      else
        p "Haven't finished translating your file to SVF - status: #{json['status']}, progress: #{json['progress']} "
        sleep 1
      end
    end
  
    return response
  end
  
  # Puts the url of the viewer for the user to open.
  def get_viewer_link(urn,access_token)
    url = "viewer.html?token=#{access_token}&urn=#{urn}"
    link = "<a href=\"#{url}\" target=\"_blank\">View Model</a>"
    return link
  end

end
