require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require 'pry'

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
    assert @cellB4.empty?
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

  def test_cell_gets_fired_upon
    @cellB4.place_ship(@cruiser)
    @cellB4.fire_upon

    assert_equal 2, @cellB4.ship.health
    assert @cellB4.fired_upon?
  end

  def test_render_without_ship
    assert_equal ".", @cellB4.render

    @cellB4.fire_upon

    assert_equal "M", @cellB4.render
  end

  def test_render_with_ship
    skip
    assert_equal ".", @cellB4.render

    @cellB4.place_ship(@cruiser)

    assert_equal "S", @cellB4.render(true)

    @cellB4.fire_upon

    assert_equal "H", @cellB4.render
    refute @cellB4.ship.sunk?
    refute @cruiser.sunk?
  end

  def test_render_with_sunk_ship
    skip
    @cellB4.place_ship(@cruiser)
    @cellB4.fire_upon
    @cruiser.hit
    @cruiser.hit

    assert @cruiser.sunk?
    assert_equal 0, @cruiser.health
    assert_equal "X", @cellB4.render
  end
end
