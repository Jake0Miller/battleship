class Board
  attr_reader :cells

  def initialize
    @cells = {}
    setup_board
  end

  def setup_board
    ("A".."D").each do |letter|
      (1..4).each do |num|
        @cells["#{letter}#{num.to_s}"] = Cell.new("#{letter}#{num.to_s}")
      end
    end
  end

  def valid_coordinate?(coord)
    return false if !coord.is_a? String
    return false if coord.length != 2
    return false if !"ABCD".include?(coord[0])
    return false if !"1234".include?(coord[1])
    true
  end
end
