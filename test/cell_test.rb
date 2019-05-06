require 'minitest/autorun'
require 'minitest/pride'
require './lib/ship'
require './lib/cell'

class CellTest < MiniTest::Test
  def setup
    @cellB4 = Cell.new("B4")
  end

  def test_it_exists
    assert_instance_of Cell, @cellB4
  end
end