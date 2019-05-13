class CoordinateGenerator
  attr_reader :board_numbers, :board_letters
  
  def initialize(board_numbers, board_letters)
    @board_numbers = board_numbers
    @board_letters = board_letters
  end

  def coord_generator(length)
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
end
