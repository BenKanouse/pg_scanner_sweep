require File.expand_path '../test_helper.rb', __FILE__

class PgActivityStatsJsonTest < MiniTest::Unit::TestCase
  def test_pg_activity_stats
    mock_stat = JsonOpenStruct.new(
      {
        datid: 1952697,
        datname: "postgres_tools_test",
        pid: 46027,
        usesysid: 10,
        usename: "test_name",
        application_name: "-e",
        client_addr: '192.168.1.1',
        client_hostname: nil,
        client_port: 50044,
        backend_start: '2017-09-27 18:21:48 UTC',
        xact_start: '2017-09-27 18:21:54 UTC',
        query_start: '2017-09-27 18:21:54 UTC',
        state_change: '2017-09-27 18:21:54 UTC',
        waiting: false,
        state: "active",
        backend_xid: nil,
        backend_xmin: "2491051",
        query: "SELECT \"pg_stat_activity\".* FROM \"pg_stat_activity\""
      }
    )
    # This might be stubbing out too much, but I'm not sure how to test the stats table.
    PgStatActivity.stub(:all, mock_stat) do
      get '/pg_activity_stats'
      assert last_response.ok?
      responce_json = "{\"datid\":1952697,\"datname\":\"postgres_tools_test\",\"pid\":46027," \
        "\"usesysid\":10,\"usename\":\"test_name\",\"application_name\":\"-e\",\"client_addr\":\"192.168.1.1\"" \
        ",\"client_hostname\":null,\"client_port\":50044,\"backend_start\":\"2017-09-27 18:21:48 UTC\"" \
        ",\"xact_start\":\"2017-09-27 18:21:54 UTC\",\"query_start\":\"2017-09-27 18:21:54 UTC\"" \
        ",\"state_change\":\"2017-09-27 18:21:54 UTC\",\"waiting\":false,\"state\":\"active\",\"backend_xid\":null,\"" \
        "backend_xmin\":\"2491051\",\"query\":\"SELECT \\\"pg_stat_activity\\\".* FROM \\\"pg_stat_activity\\\"\"}"
      assert_equal responce_json, last_response.body
    end
  end
end

class JsonOpenStruct < OpenStruct
  def to_json
    table.to_json
  end
end
