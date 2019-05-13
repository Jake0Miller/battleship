require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require './lib/coordinate_generator'
require 'pry'

class CoordinateGeneratorTest < MiniTest::Test

  def setup
    @board = Board.new(4)
    @gen = CoordinateGenerator.new(@board.board_numbers, @board.board_letters)
  end

  def test_that_it_exists
    assert_instance_of CoordinateGenerator, @gen
  end

  def test_it_has_attributes
    assert_equal ["1", "2", "3", "4"], @gen.board_numbers
  end
end
