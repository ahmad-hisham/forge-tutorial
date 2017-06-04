require 'test_helper'

class ForgeDataItemControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forge_data_item_index_url
    assert_response :success
  end

  test "should get show" do
    get forge_data_item_show_url
    assert_response :success
  end

end
