require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < MiniTest::Test
  def setup
    @board = Board.new
    # @cellB4 = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Submarine", 2)

  end

  def test_that_it_exists
    assert_instance_of Board, @board
  end

  def test_board_cells
    assert_instance_of Hash, @board.cells
    assert_instance_of Cell, @board.cells.first
    assert_equal 16, @board.cells.keys
    assert_equal 16, @board.cells.values
  end

  def test_valid_coordinate?
    assert @board.valid_coordinate?("A1")
    assert @board.valid_coordinate?("D4")
    refute @board.valid_coordinate?("A5")
    refute @board.valid_coordinate?("E1")
    refute @board.valid_coordinate?("A22")
    refute @board.valid_coordinate?(:A2)
  end

  def test_valid_placement_by_length
    refute @board.valid_placement?(@cruiser, ["A1", "A2"])
    assert @board.valid_placement?(@cruiser, ["A1", "A2", "A3"])
    assert @board.valid_placement?(@sub, ["A1", "A2"])
    refute @board.valid_placement?(@sub, ["A1", "A2", "A3"])
  end

  def test_nonconsecutive_coordinates
    refute @board.valid_placement?(cruiser, ["A1", "A2", "A4"])
    refute @board.valid_placement?(submarine, ["A1", "C1"])
    refute @board.valid_placement?(cruiser, ["A3", "A2", "A1"])
    refute @board.valid_placement?(submarine, ["C1", "B1"])
    refute @board.valid_placement?(cruiser, ["A1", "B2", "C3"])
    refute @board.valid_placement?(submarine, ["C2", "D3"])
  end

  def test_consecutive_coordinates
    assert @board.valid_placement?(submarine, ["A1", "A2"])
    assert @board.valid_placement?(cruiser, ["B1", "C1", "D1"])
  end

end
