
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
  start_game
end

# THIS NEEDS TO BE UPDATED TO CHECK FOR BAD INPUT
def create_boards
  puts "Select board size (4 to 26):"
  size = gets.chomp.to_i
  create_boards if size > 26 || size < 4
  @player_board = Board.new(size)
  @comp_board = Board.new(size)
  place_comp_ships
  place_player_ships
end

# THIS NEEDS TO BE UPDATED
def place_comp_ships
  cruiser = Ship.new("Cruiser", 3)
  sub = Ship.new("Submarine", 2)
  @comp_board.place(cruiser, ["A1", "A2", "A3"])
  @comp_board.place(sub, ["C3", "D3"])
end

def place_player_ships
  num_ships = set_num_ships
  puts "I have laid out my ships on the grid."
  puts "You now need to lay out your ships."
  ships = ask_for_ships(num_ships)
  ships.each { |ship| place_ships(ship) }
end

def place_ships(ship)
  cur_ship = Ship.new(ship[0], ship[1])
  puts "The #{cur_ship.name} is #{cur_ship.length} units long."
  puts @player_board.render(true)

  puts "Enter the squares for the #{cur_ship.name} (#{cur_ship.length} spaces):"
  example = "Example: "
  cur_ship.length.times { |i| example << "A#{i+1} " }
  puts example
  ask_for_coordinates(cur_ship)
end

def ask_for_ships(num_ships)
  ships = []
  num_ships.times do
    puts "How big should this ship be? (2-5)"
    input_size = gets.chomp.to_i
    puts "What do you want to call this ship? (eg Submarine)"
    input_name = gets.chomp
    ships << [input_name, input_size]
  end
  return ships
end

def set_num_ships
  puts "How many ships do you want to play with? (1-5)"
  input_number = gets.chomp.to_i
  if input_number < 1 && input_number > 5
    set_num_ships
  else
    return input_number
  end
end

def ask_for_coordinates(ship)
  print "> "
  coordinates = gets.chomp.split(" ")
  if !@player_board.valid_placement?(ship, coordinates)
    puts "Those are invalid coordinates. Please try again:"
    ask_for_coordinates(ship)
  end
  @player_board.place(ship, coordinates)
end

def start_game
  until game_over?
    take_turn
  end
  play?
end

def take_turn
  display_comp_board
  display_player_board
  puts "Enter the coordinate for your shot (eg B4):"
  pshot = player_shot
  @comp_board.cells[pshot].fire_upon
  cshot = comp_shot
  @player_board.cells[cshot].fire_upon
  puts display_shot_result(pshot, true)
  puts display_shot_result(cshot)
end

def player_shot
  shot = gets.chomp
  if !@comp_board.valid_coordinate?(shot) || @comp_board.cells[shot].fired_upon?
    puts "Please enter a valid coordinate (eg B2):"
    shot = player_shot
  end
  shot
end

# THIS NEEDS TO BE UPDATED. A LOT.
def comp_shot
  "A3"
end

def display_shot_result(coord, player = false)
  if player
    case @comp_board.cells[coord].render
    when "M"
      return "Your shot on #{coord} was a miss."
    when "H"
      return "Your shot on #{coord} was a hit!"
    when "X"
      return "#{coord} hit and sunk!"
    end
  else
    case @player_board.cells[coord].render
    when "M"
      return "My shot on #{coord} was a miss."
    when "H"
      return "My shot on #{coord} was a hit!"
    when "X"
      return "#{coord} hit and sunk!"
    end
  end
end

def display_comp_board
  puts "=============COMPUTER BOARD============="
  puts @comp_board.render
end

def display_player_board
  puts "==============PLAYER BOARD=============="
  puts @player_board.render(true)
end

def game_over?
  if @player_board.all_ships_sunk
    puts "I won!"
    return true
  end
  if @comp_board.all_ships_sunk
    puts "You won!"
    return true
  end
  false
end

start
