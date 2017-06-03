require 'test_helper'

class ForgeDataProjectControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get forge_data_project_index_url
    assert_response :success
  end

  test "should get show" do
    get forge_data_project_show_url
    assert_response :success
  end

end
