require 'test_helper'

class ForgeViewerControllerTest < ActionDispatch::IntegrationTest
  test "should get get_viewer_link" do
    get forge_viewer_get_viewer_link_url
    assert_response :success
  end

end
