require_relative "board"
require "yaml"

class Minesweeper
  def initialize
    @board = Board.new
  end

  def directions
    puts "r = reveal tile / f = flag tile / s = save game / o = load previous save"
    puts "Please enter a code, followed by a position (e.g. 'r,0,0'): "
    print "> "
  end
  
  # TODO: Valid input check
  def parse_input
    code, row, col = gets.chomp.split(",")
    [code, [row.to_i, col.to_i]]
  end

  def take_action(action, position)
    tile = @board[position]
    case action.downcase
    when "r"
      tile.reveal
    when "f"
      tile.flip_flag if !tile.revealed?
    when "s"
      save_game
    when "o"
      open_game
    end
  end

  def run
    until @board.game_over?
      @board.render
      directions
      action, position = parse_input
      take_action(action, position)
    end
    
    puts "YOU WON!! :)" if @board.win?
    
    if @board.lose?
      @board.reveal
      puts "YOU LOSE. :("
    end
  end

  def save_game
    File.open("recent.yml", "w") { |file| file.write(@board.to_yaml) }
    puts "Game saved."
  end

  def open_game
    if File.exist?("recent.yml")
      @board = YAML.load(File.read("recent.yml"))
    else
      puts "No previous saves."
    end
  end
end

game = Minesweeper.new
game.run