require 'test_helper'

class UploadSampleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get upload_sample_index_url
    assert_response :success
  end

end
