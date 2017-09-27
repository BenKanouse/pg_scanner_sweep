require File.expand_path '../test_helper.rb', __FILE__

class MyTest < MiniTest::Unit::TestCase
  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Hello world!", last_response.body
  end
end
