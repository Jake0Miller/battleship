require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'

class ShipTest < MiniTest::Test
  def setup
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Sub", 2)
  end

  def test_that_it_exists
    assert_instance_of Ship, @cruiser 
  end

end
