class ShotCaller
  attr_reader :grid_cells, :ships

  def initialize(board, ships)
    @board = board
    @ships = ships
    @board_letters = board.board_letters
    @board_numbers = board.board_numbers
    @grid_size = set_smallest_ship_size
    @grid_cells = setup_cells
  end

  def set_smallest_ship_size
    @ships.min { |ship_a, ship_b| ship_a[1] <=> ship_b[1] }[1].to_i
  end

  def setup_cells
    cell_hash = {}
    @board_letters.each do |letter|
      @board_numbers.each do |num|
        if (letter.ord+num.to_i-1-"A".ord) % @grid_size == 0
          cell_hash["#{letter}#{num}"] = Cell.new("#{letter}#{num}")
        end
      end
    end
    cell_hash
  end

  def call_shot
    hits = @board.cells.keys.find_all { |key| @board.cells[key].render == "H" }
    if hits.empty?
      return call_grid_shot
    else
      return shoot_at_target(hits)
    end
  end

  def call_grid_shot
    shot = @grid_cells.keys.sample
    @grid_cells.delete(shot)
    shot
  end

  def shoot_at_target(hits)
    if hits.length == 1
      fire_randomly(hits.first)
    else
      fire_in_line(hits)
    end

    # horiz_or_vert = rand(0..1)
    # if horiz_or_vert == 0
    #   return shoot_horiz
    # else
    #   return shoot_vert
    # end
  end

  def fire_randomly(target)
    targets = []

    targets << bottom_target(target)
    targets << top_target(target)
    targets << left_target(target)
    targets << right_target(target)

    targets.find_all do |target|
      @board.valid_coordinate?(target) && !@board.cells[target].fired_upon?
    end.sample
  end

  def bottom_target(target)
    "#{target[0]}#{target[1..-1].next}"
  end

  def top_target(target)
    "#{target[0]}#{(target[1..-1].to_i-1).to_s}"
  end

  #
  def left_target(target)
    "#{(target[0].ord-1).chr}#{target[1..-1]}"
  end

  def right_target(target)
    "#{target[0].next}#{target[1..-1]}"
  end

  def fire_in_line(hits)

  end

  def shoot_horiz

  end

  def shoot_vert

  end
end
