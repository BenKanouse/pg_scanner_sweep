require 'test_helper'

class PgStatActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    size = PgStatActivity.all.size
    get pg_stat_activities_url

    assert_response :success
    assert_equal(size, JSON.parse(@response.body).size)
  end

  test "should show pg_stat_activity" do
    datid = PgStatActivity.all.first.datid
    get pg_stat_activity_url(datid)

    assert_response :success
    assert_equal(datid, JSON.parse(@response.body)["datid"])
  end
end
