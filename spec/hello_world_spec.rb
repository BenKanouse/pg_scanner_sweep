require 'spec_helper.rb'

class MyTest < MiniTest::Unit::TestCase
  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal "Hello world!", last_response.body
  end
end
