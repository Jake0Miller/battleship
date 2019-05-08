class Board
  attr_reader :cells

  def initialize
    @cells = {}
    @board_size = 4
    @board_letters = []
    @board_numbers = []
    setup_board
  end

  def setup_board
    (65.upto(64+@board_size)).each { |letter| @board_letters << letter.chr }
    (1.upto(@board_size)).each { |num| @board_numbers << num.to_s }
    @board_letters.each do |letter|
      @board_numbers.each do |num|
        @cells["#{letter.chr}#{num.to_s}"] = Cell.new("#{letter.chr}#{num.to_s}")
      end
    end
  end

  def valid_coordinate?(coord)
    return false if !coord.is_a? String
    return false if coord.length != 2
    return false if !@board_letters.include?(coord[0])
    return false if !@board_numbers.include?(coord[1])
    true
  end

  def valid_placement?(ship, coords)
    return false if ship.length != coords.length
    return false if coords.any? { |coord| valid_coordinate?(coord) == false }
    return false if coords.any? { |coord| !@cells[coord].empty? }
    return check_letters_same(ship,coords) if coords[0][0] == coords[1][0]
    return check_numbers_same(ship,coords) if coords[0][1] == coords[1][1]
  end

  def check_letters_same(ship,coords)
    (ship.length-1).times do |i|
      return false if coords[i][0] != coords[i+1][0]
      return false if coords[i][1].next != coords[i+1][1]
    end
    true
  end

  def check_numbers_same(ship,coords)
    (ship.length-1).times do |i|
      return false if coords[i][0].next != coords[i+1][0]
      return false if coords[i][1] != coords[i+1][1]
    end
    true
  end

  def place(ship, coords)
    return nil if !valid_placement?(ship, coords)
    coords.each { |coord| @cells[coord].place_ship(ship) }
  end

  def render(unhide = false)
     board = "  "
     @board_numbers.each do |num|
       board << num + " "
     end
     board << "\n"
     @board_letters.each do |cur_letter|
       board << cur_letter+" "
       @board_numbers.each do |number|
         board << @cells[cur_letter+number.to_s].render(unhide)+" "
       end
       board << "\n"
     end
     board
  end
end
