require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < MiniTest::Test
  make_my_diffs_pretty!

  def setup
    @board = Board.new(12)
    @sub = Ship.new("Submarine", 2)
    @cruiser = Ship.new("Cruiser", 3)
  end

  def test_valid_coordinate?
    assert @board.valid_coordinate?("A10")
    assert @board.valid_coordinate?("D12")
  end

  def test_valid_placement
    assert @board.valid_placement?(@sub, ["A10", "A11"])
    assert @board.valid_placement?(@cruiser, ["B10", "C10", "D10"])
  end

  def test_ship_is_placed
    @board.place(@sub, ["A10", "A11"])
    @board.place(@cruiser, ["B10", "C10", "D10"])

    assert_equal "Submarine", @board.cells["A11"].ship.name
    assert_equal "Cruiser", @board.cells["C10"].ship.name
  end

  def test_render_board_with_ship
    @board.place(@sub, ["A10", "A11"])
    @board.place(@cruiser, ["B10", "C10", "D10"])

    expected = "  1 2 3 4 5 6 7 8 9 10 11 12 \n" +
              "A . . . . . . . . . S S . \n" +
              "B . . . . . . . . . S . . \n" +
              "C . . . . . . . . . S . . \n" +
              "D . . . . . . . . . S . . \n" +
              "E . . . . . . . . . . . . \n" +
              "F . . . . . . . . . . . . \n" +
              "G . . . . . . . . . . . . \n" +
              "H . . . . . . . . . . . . \n" +
              "I . . . . . . . . . . . . \n" +
              "J . . . . . . . . . . . . \n" +
              "K . . . . . . . . . . . . \n" +
              "L . . . . . . . . . . . . \n" +

    actual = @board.render(true)

    assert_equal expected, actual
  end
end
