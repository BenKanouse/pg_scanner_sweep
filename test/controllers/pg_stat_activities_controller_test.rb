require 'test_helper'

class PgStatActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    size = PgStatActivity.all.size
    get pg_stat_activities_url

    assert_response :success
    assert_equal(size, JSON.parse(@response.body).size)
  end

  test "should show a pg_stat_activity" do
    pid = PgStatActivity.all.first.pid
    get pg_stat_activity_url(pid)

    assert_response :success
    assert_equal(pid, JSON.parse(@response.body)["pid"])
  end

  test "should kill the process running that activity" do
    sleep_query = 'select pg_sleep(10)'

    fork do
      exec(ApplicationRecord.connection.execute(sleep_query))
    rescue
    end
    sleep 0.1
    pg_stat = PgStatActivity.where(query: sleep_query).first
    assert_equal "active", pg_stat.state
    assert_not_nil pg_stat.pid

    delete pg_stat_activity_url(pg_stat.pid)
    assert_response :success
    assert_equal(pg_stat.pid, JSON.parse(@response.body)["pid"])
  end
end
