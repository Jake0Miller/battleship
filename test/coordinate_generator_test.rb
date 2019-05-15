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
    @sub = Ship.new("Sub", 2)
    @gen = CoordinateGenerator.new
  end

  def test_that_it_exists
    assert_instance_of CoordinateGenerator, @gen
  end

  def test_it_generates_valid_coordinates
    assert @board.valid_placement?(@sub.length, @gen.generate(@board, 2))
  end
end
