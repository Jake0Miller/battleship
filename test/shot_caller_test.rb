require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/shot_caller'
require 'pry'

class ShotCallerTest < MiniTest::Test
  def setup
    @board = Board.new(4)
    # @sub = Ship.new("Sub", 2)
    # @cruiser = Ship.new("Cruiser", 3)
    @ships = [["Sub", "2"], ["Cruiser", "3"]]
    @shooter = ShotCaller.new(4, @ships)
  end

  def test_that_it_exists
    assert_instance_of ShotCaller, @shooter
  end

  def test_it_has_attributes
    assert_equal @ships = [["Sub", "2"], ["Cruiser", "3"]], @shooter.ships
  end

  def test_it_sets_up_cells
    assert_equal 8, @shooter.cells.length
  end
end
