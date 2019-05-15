class CoordinateGenerator
  attr_reader :board_numbers, :board_letters

  def initialize
  end

  def generate(board,length)
    number = board.board_numbers.sample
    letter = board.board_letters.sample

    horiz_or_vert = []

    coords = [letter+number]
    make_coords_with_same_letter(coords,length)
    horiz_or_vert << coords if board.valid_placement?(length,coords)

    coords = [letter+number]
    make_coords_with_same_number(coords,length)
    horiz_or_vert << coords if board.valid_placement?(length,coords)

    horiz_or_vert.sample
  end

  def make_coords_with_same_letter(coords,length)
    cur_coord = coords[0]
    (length-1).times do
      cur_coord = cur_coord[0] + cur_coord[1].next
      coords << cur_coord
    end
  end

  def make_coords_with_same_number(coords,length)
    cur_coord = coords[0]
    (length-1).times do
      cur_coord = cur_coord[0].next + cur_coord[1]
      coords << cur_coord
    end
  end
end
