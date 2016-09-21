require 'test_helper'

class AnalysesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @analysis = analyses(:one)
  end

  test "should get new" do
    get new_analysis_url
    assert_response :success
  end
end
