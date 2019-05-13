class ShotCaller
  attr_reader :cells, :ships

  def initialize(board_size, ships)
    @board_size = board_size
    @cells = {}
    @ships = ships
    @board_letters = []
    @board_numbers = []
    setup_cells
  end

  def setup_cells
    smallest_ship_size = @ships.min_by { |ship| ship[1] }[1].to_i
    row = 'A'.ord
    col = 1
    (row .. row+@board_size-1).each { |letter| @board_letters << letter.chr }
    (col .. @board_size).each { |num| @board_numbers << num.to_s }
    @board_letters.each do |letter|
      @board_numbers.each do |num|
        if (letter.ord+num.to_i-row-col) % smallest_ship_size == 0
          @cells["#{letter}#{num}"] = Cell.new("#{letter}#{num}")
        end
      end
    end
  end

  def call_shot
    shot = @cells.keys.sample
    @cells.delete(shot)
    shot
  end
end
