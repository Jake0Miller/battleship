class CoordinateGenerator
  attr_reader :board_numbers, :board_letters

  def initialize(board_numbers, board_letters)
    @board_numbers = board_numbers
    @board_letters = board_letters
  end

  def generate(length)
    number = @board_numbers[0..-1*length].sample
    letter = @board_letters[0..-1*length].sample
    coords = [letter+number]
    right_or_down = rand(0..1)
    if right_or_down == 0
      coords = make_coords_with_same_letter(coords,length)
    else
      coords = make_coords_with_same_number(coords,length)
    end
    coords
  end

  def make_coords_with_same_letter(coords,length)
    cur_coord = coords[0]
    (length-1).times do
      cur_coord = cur_coord[0] + cur_coord[1].next
      coords << cur_coord
    end
    coords
  end

  def make_coords_with_same_number(coords,length)
    cur_coord = coords[0]
    (length-1).times do
      cur_coord = cur_coord[0].next + cur_coord[1]
      coords << cur_coord
    end
    coords
  end
end
