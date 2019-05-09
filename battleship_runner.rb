
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
  
end

start
