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
    @sub = Ship.new("Sub", 2)
    #@cruiser = Ship.new("Cruiser", 3)
    @ships = [["Sub", "2"], ["Cruiser", "3"]]
    @shooter = ShotCaller.new(@board, @ships)
  end

  def test_that_it_exists
    assert_instance_of ShotCaller, @shooter
  end

  def test_it_has_attributes
    assert_equal @ships = [["Sub", "2"], ["Cruiser", "3"]], @shooter.ships
  end

  def test_it_sets_up_cells
    assert_equal 8, @shooter.grid_cells.length
  end

  def test_it_calls_shots
    shot = @shooter.call_shot

    assert @board.cells.include?(shot)
    assert_nil @shooter.grid_cells[shot]
  end

  def test_hit_logic
    @board.place(@sub,["B1", "B2"])
    @board.cells["B2"].fire_upon
    shot = @shooter.call_shot
    
    assert ["B1", "B3", "A2", "C2"].include?(shot)
  end
end
