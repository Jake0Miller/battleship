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
    hit = "\e[31mH\e[0m"
    hits = @board.cells.keys.find_all { |key| @board.cells[key].render == hit }
    shot = hits.empty? ? call_grid_shot : shoot_at_target(hits)
    @grid_cells.delete(shot)
    shot
  end

  def call_grid_shot
    @grid_cells.keys.sample
  end

  def shoot_at_target(hits)
    hits.length == 1 ? fire_randomly(hits.first) : fire_in_line(hits)
  end

  def fire_randomly(target)
    targets = []

    targets << bottom_target(target)
    targets << top_target(target)
    targets << left_target(target)
    targets << right_target(target)

    sample_targets(targets)
  end

  def right_target(target)
    "#{target[0]}#{target[1..-1].next}"
  end

  def left_target(target)
    "#{target[0]}#{(target[1..-1].to_i-1).to_s}"
  end

  def top_target(target)
    "#{(target[0].ord-1).chr}#{target[1..-1]}"
  end

  def bottom_target(target)
    "#{target[0].next}#{target[1..-1]}"
  end

  def sample_targets(targets)
    targets.find_all do |target|
      @board.valid_coordinate?(target) && !@board.cells[target].fired_upon?
    end.sample
  end

  def fire_in_line(hits)
    targets = []
    if @board.check_letters_same(hits.length,hits)
      targets << left_target(hits.min)
      targets << right_target(hits.max)
    end
    if @board.check_numbers_same(hits.length,hits)
      targets << top_target(hits.min)
      targets << bottom_target(hits.max)
    end
    targets = sample_targets(targets)
    while targets.nil?
      targets = fire_randomly(hits.sample)
    end
    targets
  end
end
