require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'
require './lib/board'
require 'pry'

class BoardTest < MiniTest::Test
  def setup
    @board = Board.new(4)
    @cruiser = Ship.new("Cruiser", 3)
    @sub = Ship.new("Submarine", 2)
  end

  def test_that_it_exists
    assert_instance_of Board, @board
  end

  def test_board_cells
    assert_instance_of Hash, @board.cells
    assert_instance_of Cell, @board.cells["A1"]
    assert_equal 16, @board.cells.keys.length
    assert_equal 16, @board.cells.values.length
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
    refute @board.valid_placement?(@cruiser.length, ["A1", "A2"])
    assert @board.valid_placement?(@cruiser.length, ["A1", "A2", "A3"])
    assert @board.valid_placement?(@sub.length, ["A1", "A2"])
    refute @board.valid_placement?(@sub.length, ["A1", "A2", "A3"])
  end

  def test_nonconsecutive_coordinates
    refute @board.valid_placement?(@sub.length, ["A4", "A5"])
    refute @board.valid_placement?(@cruiser.length, ["A1", "A2", "A4"])
    refute @board.valid_placement?(@sub.length, ["A1", "C1"])
    refute @board.valid_placement?(@cruiser.length, ["A3", "A2", "A1"])
    refute @board.valid_placement?(@sub.length, ["C1", "B1"])
    refute @board.valid_placement?(@cruiser.length, ["A1", "B2", "C3"])
    refute @board.valid_placement?(@sub.length, ["C2", "D3"])
  end

  def test_consecutive_coordinates
    assert @board.valid_placement?(@sub.length, ["A1", "A2"])
    assert @board.valid_placement?(@cruiser.length, ["B1", "C1", "D1"])
  end

  def test_ship_is_placed
    assert_nil @board.cells["A1"].ship
    assert_nil @board.cells["A2"].ship
    assert_nil @board.cells["A3"].ship

    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert_instance_of Ship, @board.cells["A1"].ship
    assert_instance_of Ship, @board.cells["A2"].ship
    assert_instance_of Ship, @board.cells["A3"].ship
    assert_nil @board.cells["A4"].ship
  end

  def test_cell_has_same_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])

    assert @board.cells["A1"].ship == @board.cells["A2"].ship
  end

  def test_overlapping_ships
    @board.place(@cruiser, ["A1", "A2", "A3"])

    refute @board.valid_placement?(@sub, ["A1", "B1"])
  end

  def test_render_empty_board

    expected = "  1 2 3 4 \n" +
              "A . . . . \n" +
              "B . . . . \n" +
              "C . . . . \n" +
              "D . . . . \n"
    actual = @board.render

    assert_equal expected, actual
  end

  def test_render_board_with_ship
    @board.place(@cruiser, ["A1", "A2", "A3"])

    expected = "  1 2 3 4 \n" +
              "A . . . . \n" +
              "B . . . . \n" +
              "C . . . . \n" +
              "D . . . . \n"

    actual = @board.render

    assert_equal expected, actual

    expected = "  1 2 3 4 \n" +
              "A S S S . \n" +
              "B . . . . \n" +
              "C . . . . \n" +
              "D . . . . \n"

    actual = @board.render(true)

    assert_equal expected, actual
  end

  def test_board_with_hits_and_misses
    @board.place(@cruiser, ["A1", "A2", "A3"])
    @board.place(@sub, ["C1", "D1"])

    @board.cells["A1"].fire_upon
    @board.cells["D1"].fire_upon
    @board.cells["B4"].fire_upon
    @board.cells["C1"].fire_upon

    expected = "  1 2 3 4 \n" +
              "A \e[31mH\e[0m . . . \n" +
              "B . . . M \n" +
              "C X . . . \n" +
              "D X . . . \n"

    actual = @board.render

    assert_equal expected, actual

    expected = "  1 2 3 4 \n" +
              "A \e[31mH\e[0m S S . \n" +
              "B . . . M \n" +
              "C X . . . \n" +
              "D X . . . \n"

    actual = @board.render(true)

    assert_equal expected, actual
  end
end
