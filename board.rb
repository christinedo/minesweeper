require_relative "tile"

class Board
  def initialize
    @grid = Array.new(9) do |row|
      Array.new(9) do |col|
        Tile.new(self, [row, col])
      end
    end
    place_random_bombs
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def place_random_bombs
    num_bombs = 0
    max_bombs = 10
    while num_bombs < max_bombs
      row = rand(0...@grid.length)
      col = rand(0...@grid.length)
      pos = [row, col]
      
      tile = self[pos]
      if !tile.bomb?
        tile.plant_bomb
        num_bombs += 1
      end
    end
  end

  def lose?
    @grid.flatten.any? { |tile| tile.revealed? && tile.bomb? }
  end

  def win?
    # when there are no more hidden tiles that are not bombs
    @grid.flatten.all? { |tile| tile.bomb? != tile.revealed? }
  end

  def game_over?
    win? || lose?
  end

  def render(game_over = false)
    puts "  #{(0..8).to_a.join(" ")}"
    @grid.each_with_index do |row, i|
      display_row = row.map do |tile|
        game_over ? tile.reveal_at_end : tile.render
      end
      print "#{i} "
      puts display_row.join(" ")
    end
  end

  def reveal
    render(true)
  end
end

# b = Board.new
# b.reveal
# puts
# b.render