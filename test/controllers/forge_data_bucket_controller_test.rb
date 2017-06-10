require 'test_helper'

class ForgeDataBucketControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forge_data_bucket_index_url
    assert_response :success
  end

  test "should get show" do
    get forge_data_bucket_show_url
    assert_response :success
  end

end
