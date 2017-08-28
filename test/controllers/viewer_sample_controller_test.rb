require 'test_helper'

class ViewerSampleControllerTest < ActionDispatch::IntegrationTest
  test "should get run" do
    get viewer_sample_run_url
    assert_response :success
  end

end
