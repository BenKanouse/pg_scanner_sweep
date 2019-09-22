require 'test_helper'

class PgStatActivityTest < ActiveSupport::TestCase
  test "is a readonly model" do
    assert PgStatActivity.first.readonly? == true
  end
end
