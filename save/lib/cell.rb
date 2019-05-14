class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def fired_upon?
    @fired_upon
  end

  def place_ship(ship)
    @ship = ship
  end

  def fire_upon
    if @ship != nil and @fired_upon == false
      @ship.hit
    end
    @fired_upon = true
  end

  def render(unhide = false)
    if @ship != nil && @ship.sunk?
      return "X"
    elsif !fired_upon? && (empty? || !unhide)
      return "."
    elsif !fired_upon? && unhide && !empty?
      return "S"
    elsif fired_upon? && empty?
      return "M"
    elsif fired_upon? && !empty?
      return "H"
    end
  end
end
