require 'test_helper'

class ForgeDerivativeControllerTest < ActionDispatch::IntegrationTest
  test "should get translate" do
    get forge_derivative_translate_url
    assert_response :success
  end

  test "should get translate_start" do
    get forge_derivative_translate_start_url
    assert_response :success
  end

  test "should get translate_progress" do
    get forge_derivative_translate_progress_url
    assert_response :success
  end

end
