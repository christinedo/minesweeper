class Tile
  ADJACENT = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  def initialize(board, position)
    @board = board
    @position = position
    @bomb = false
    @flagged = false
    @revealed = false
  end

  def bomb?
    @bomb
  end

  def flagged?
    @flagged
  end

  def revealed?
    @revealed
  end

  def plant_bomb
    @bomb = true
  end

  def neighbors
    neighbor_positions = ADJACENT.map do |x, y|
      [@position[0] + x, @position[1] + y]
    end.select do |row, col|
      row.between?(0, 8) && col.between?(0, 8)
    end

    neighbor_positions.map { |pos| @board[pos] }
  end

  def neighbor_bomb_count
    neighbors.select(&:bomb?).count
  end

  def reveal
    return self if flagged? || revealed? 

    @revealed = true
    if !bomb? && neighbor_bomb_count.zero?
      neighbors.each(&:reveal)
    end
  end

  def render
    if flagged?
      "F"
    elsif revealed?
      neighbor_bomb_count.zero? ? "_" : neighbor_bomb_count.to_s
    else
      "*"
    end
  end

  def reveal_at_end
    if flagged?
      bomb? ? "F" : "B̶"
    elsif bomb?
      revealed? ? "X" : "B"
    else
      neighbor_bomb_count.zero? ? "_" : neighbor_bomb_count.to_s
    end
  end

  def flip_flag
    @flagged = !@flagged
  end

  def inspect
    # print select properties with "p"
    {
      "position" => @position,
      "bomb" => @bomb,
      "flagged" => @flagged,
      "revealed" => @revealed
    }.inspect
  end
end