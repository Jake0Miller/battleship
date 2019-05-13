class Board
  attr_reader :cells, :ships, :board_letters, :board_numbers

  def initialize(board_size)
    @cells = {}
    @board_size = board_size
    @board_letters = []
    @board_numbers = []
    @ships = []
    setup_board
  end

  def setup_board
    row = 'A'.ord
    col = 1
    (row .. row+@board_size-1).each { |letter| @board_letters << letter.chr }
    (col .. @board_size).each { |num| @board_numbers << num.to_s }
    @board_letters.each do |letter|
      @board_numbers.each do |num|
        @cells["#{letter}#{num}"] = Cell.new("#{letter}#{num}")
      end
    end
  end

  def valid_coordinate?(coord)
    return false if !coord.is_a? String
    return false if coord.length > @board_size.to_s.length + 1
    return false if !@board_letters.include?(coord[0])
    return false if !@board_numbers.include?(coord[1..-1])
    true
  end

  def valid_placement?(ship, coords)
    return false if ship.length != coords.length
    return false if coords.any? { |coord| valid_coordinate?(coord) == false }
    return false if coords.any? { |coord| !@cells[coord].empty? }
    return check_letters_same(ship,coords) if coords[0][0] == coords[1][0]
    return check_numbers_same(ship,coords) if coords[0][1..-1] == coords[1][1..-1]
  end

  def check_letters_same(ship,coords)
    (ship.length-1).times do |i|
      return false if coords[i][0] != coords[i+1][0]
      return false if coords[i][1..-1].next != coords[i+1][1..-1]
    end
    true
  end

  def check_numbers_same(ship,coords)
    (ship.length-1).times do |i|
      return false if coords[i][0].next != coords[i+1][0]
      return false if coords[i][1..-1] != coords[i+1][1..-1]
    end
    true
  end

  def place(ship, coords)
    return nil if !valid_placement?(ship, coords)
    coords.each { |coord| @cells[coord].place_ship(ship) }
    @ships << ship
  end

  def render(unhide = false)
    board = ""
    print_doubles(board) if @board_size > 9
    print_columns(board)
    print_all_rows(board, unhide)
    board
  end

  def print_doubles(board)
    10.times do
      board << "  "
    end
    (10..@board_size).each do |i|
      board << i.to_s[0]+" "
    end
    board << "\n"
    board
  end

  def print_columns(board)
    board << "  "
    @board_numbers.each do |num|
     board << num[-1] + " "
    end
    board << "\n"
    board
  end

  def print_all_rows(board, unhide)
    @board_letters.each do |cur_letter|
      board << cur_letter + " "
      @board_numbers.each do |number|
        board << @cells[cur_letter+number.to_s].render(unhide)+" "
      end
      board << "\n"
    end
  end

  def all_ships_sunk
    @ships.all? { |ship| ship.sunk? }
  end
end
