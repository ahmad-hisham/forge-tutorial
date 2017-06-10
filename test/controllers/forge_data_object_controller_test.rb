require 'test_helper'

class ForgeDataObjectControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forge_data_object_index_url
    assert_response :success
  end

  test "should get show" do
    get forge_data_object_show_url
    assert_response :success
  end

  test "should get upload" do
    get forge_data_object_upload_url
    assert_response :success
  end

end
