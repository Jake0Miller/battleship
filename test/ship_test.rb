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

  def test_ship_starts_with_full_health
    assert_equal 3, @cruiser.health
    assert_equal 2, @sub.health
  end

  def test_ship_has_not_sunk
    refute @cruister.sunk?
    refute @sub.sunk?
  end

  def test_ship_gets_hit
    @cruiser.hit
    @sup.hit

    assert_equal 2, @cruiser.health
    assert_equal 1, @sub.health

    @cruiser.hit
    @sup.hit

    assert_equal 1, @cruiser.health
    assert_equal 0, @sub.health
    assert @sub.sunk?

    @cruiser.hit

    assert_equal 0, @cruiser.health
    assert @cruiser.sunk?
  end

end
