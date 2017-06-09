require 'test_helper'

class ForgeAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get forge_login_url
    assert_response :success
  end
  test "should get callback" do
    get forge_login_callback_url
    assert_response :success
  end
end
