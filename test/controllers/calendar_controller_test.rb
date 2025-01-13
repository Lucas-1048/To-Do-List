require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  test "deve acessar a página do calendário" do
    get calendar_path
    assert_response :success
  end
end
