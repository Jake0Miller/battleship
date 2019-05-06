require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < MiniTest::Test
  def setup
    @cellB4 = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_it_exists
    assert_instance_of Cell, @cellB4
  end

  def test_has_coordinate
    assert_equal "B4", @cellB4.coordinate
  end

  def test_cell_starts_without_a_ship
    assert_nil @cellB4.ship
  end

  def test_cell_starts_empty
    assert cell.empty?
  end

  def test_cell_accepts_ship
    @cellB4.place_ship(@cruiser)

    refute @cellB4.empty?
    assert_equal @cruiser, @cellB4.ship
  end

  def test_cell_starts_not_fired_upon
    @cellB4.place_ship(@cruiser)

    refute @cellB4.fired_upon?
  end
end
