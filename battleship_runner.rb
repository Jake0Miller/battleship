
require './lib/cell'
require './lib/board'
require './lib/ship'
require 'pry'


def start
  puts "Welcome to BATTLESHIP"
  play?

  puts "****** Game over! ******"
end

def play?
  puts "Enter p to play. Enter q to quit."
  answer = gets.chomp.downcase
  if answer == "q"
    puts "Goodbye!"
    exit
  elsif answer == "p"
    create_boards
  else
    play?
  end
end

def create_boards
  puts "Select board size (4 to 26):"
  size = gets.chomp.to_i
  create_boards if size > 26 || size < 4
  @player_board = Board.new(size)
  @comp_board = Board.new(size)
  place_comp_ships
  place_player_ships
end

def place_comp_ships
  cruiser = Ship.new("Cruiser", 3)
  sub = Ship.new("Submarine", 2)
  @comp_board.place(cruiser, ["A1", "A2", "A3"])
  @comp_board.place(sub, ["C3", "D3"])
end

def place_player_ships
  puts "I have laid out my ships on the grid."
  puts "You now need to lay out your ships."
  puts "The Cruiser is two units long and the Submarine is three units long."
  puts @player_board.render(true)
  cruiser = Ship.new("Cruiser", 3)
  sub = Ship.new("Submarine", 2)

  def ask_for_coordinates(ship)
    print "> "
    coordinates = gets.chomp.split(" ")
    if !@player_board.valid_placement?(ship, coordinates)
      puts "Those are invalid coordinates. Please try again:"
      ask_for_coordinates(ship)
    end
    @player_board.place(ship, coordinates)
  end

  puts "Enter the squares for the Cruiser (3 spaces):"
  puts "Example: A1 A2 A3"
  ask_for_coordinates(cruiser)
  puts "Enter the squares for the Sub (2 spaces):"
  puts "Example: A1 A2"
  ask_for_coordinates(sub)

end

start
