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

  def test_ship_has_name
    assert_equal "Cruiser", @cruiser.name
    assert_equal "Sub", @sub.name
  end

  def test_ship_has_length
    assert_equal 3, @cruiser.length
    assert_equal 2, @sub.length
  end
end
