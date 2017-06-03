require 'test_helper'

class ForgeDataHubControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forge_data_hub_index_url
    assert_response :success
  end

  test "should get show" do
    get forge_data_hub_show_url
    assert_response :success
  end

end
