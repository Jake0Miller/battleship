require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < MiniTest::Test
  def setup
    board = Board.new
    # @cellB4 = Cell.new("B4")
    # @cruiser = Ship.new("Cruiser", 3)
  end

  def test_that_it_exists
    assert_instance_of Board, board
  end
  
end
