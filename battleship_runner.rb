require './lib/cell'
require './lib/board'
require './lib/ship'
require './lib/coordinate_generator'
require './lib/shot_caller'
require 'pry'

@min_board_size = 4
@max_board_size = 26
@min_num_ships = 1
@max_num_ships = 5
@min_ship_length = 2
@max_ship_length = 5

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

def create_boards
  puts "Select board size (#{@min_board_size} to #{@max_board_size}):"
  board_size = gets.chomp.to_i
  create_boards if board_size > @max_board_size || board_size < @min_board_size
  @player_board = Board.new(board_size)
  @comp_board = Board.new(board_size)
  place_ships
end

def place_ships
  num_ships = set_num_ships
  puts " "
  puts "Create your fleet!\n"
  ships = ask_for_ships(num_ships)
  puts " "
  ships.each { |ship| place_player_ships(ship) }
  ships.each { |ship| place_comp_ships(ship) }
  @shooter = ShotCaller.new(@player_board,ships)
  puts " "
  puts "All ships have been placed."
  puts "Let the game begin!"
  puts " "
end

def set_num_ships
  puts "How many ships do you want to play with? (#{@min_num_ships}-#{@max_num_ships})"
  input_number = gets.chomp.to_i
  if input_number < @min_num_ships || input_number > @max_num_ships
    set_num_ships
  else
    return input_number
  end
end

def ask_for_ships(num_ships)
  ships = []
  num_ships.times do
    ships << [set_ship_name, set_ship_size]
  end
  return ships
end

def set_ship_name
  puts "What do you want to call this ship? (eg Submarine)"
  input_name = gets.chomp
end

def set_ship_size
  puts "How big should this ship be? (#{@min_ship_length}-#{@max_ship_length})"
  input_size = gets.chomp.to_i
  if input_size < @min_ship_length || input_size > @max_ship_length
    set_ship_size
  else
    return input_size
  end
end

def place_player_ships(ship)
  cur_ship = Ship.new(ship[0], ship[1])
  puts "The #{cur_ship.name} is #{cur_ship.length} units long."
  puts @player_board.render(true)
  puts "Enter the coordinates for the #{cur_ship.name} (#{cur_ship.length} spaces):"
  puts (0..cur_ship.length-1).inject("Example: ") { |text, i| text + "A#{i+1} "}
  ask_for_coordinates(cur_ship)
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

def place_comp_ships(ship)
  cur_ship = Ship.new(ship[0], ship[1])
  coord_generator = CoordinateGenerator.new(@comp_board.board_numbers, @comp_board.board_letters)
  placed = nil
  while placed.nil?
    placed = @comp_board.place(cur_ship, coord_generator.generate(ship[1]))
  end
end

def start_game
  until game_over?
    take_turn
  end
  play?
end

def take_turn
  display_comp_board(false)
  display_player_board
  puts "Enter the coordinate for your shot (eg B4):"
  pshot = player_shot
  @comp_board.cells[pshot].fire_upon
  cshot = comp_shot
  @player_board.cells[cshot].fire_upon
  puts display_shot_result(pshot, true)
  puts display_shot_result(cshot)
end

def display_comp_board(unhide)
  puts "=============COMPUTER BOARD============="
  puts @comp_board.render(unhide)
end

def display_player_board
  puts "==============PLAYER BOARD=============="
  puts @player_board.render(true)
end

def player_shot
  shot = gets.chomp
  if !@comp_board.valid_coordinate?(shot) || @comp_board.cells[shot].fired_upon?
    puts "Please enter a valid coordinate (eg B2):"
    shot = player_shot
  end
  shot
end

def comp_shot
  @shooter.call_shot
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

def game_over?
  return false if !@player_board.all_ships_sunk && !@comp_board.all_ships_sunk
  display_comp_board(true)
  display_player_board
  if @player_board.all_ships_sunk && @comp_board.all_ships_sunk
    puts "It was a tie!"
  elsif @player_board.all_ships_sunk
    puts "I won!"
  elsif @comp_board.all_ships_sunk
    puts "You won!"
  end
  true
end

start
