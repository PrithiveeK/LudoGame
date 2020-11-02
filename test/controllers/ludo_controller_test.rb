require 'test_helper'

class LudoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ludo_index_url
    assert_response :success
  end

end
