class Game
  attr_accessor :board, :current_player, :other_player
  def initialize(board = Board.new)
    @board = board
    players = [Player.new, Player.new]
    get_players(players[0], players[1])
    @current_player, @other_player = players.shuffle
  end

  def play
    loop do
      board.display_grid
      puts "It's #{@current_player.name}'s turn to pick a space."
      board.set_cell(@current_player.marker)
      if board.game_over?
        puts "#{@current_player.name} wins!" if board.game_over? == :winner
        puts "It's a tie!" if board.game_over? == :draw
        board.display_grid
        return
      else
        switch_players
      end
    end
  end

  private

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def get_players(player1, player2)
    puts "First player, enter your name:"
    player1.collect_name
    puts "Now, choose a character to be your marker:"
    player1.collect_marker
    puts "Second player, enter your name:"
    player2.collect_name
    puts "Now, choose a character to be your marker:"
    player2.collect_marker
  end
end

class Board
  attr_accessor :grid
  def initialize(grid = default_grid)
    @grid = grid
  end

  def get_cell(x, y)
    grid[invert_y(y)][x]
  end

  def set_cell(new_value)
    target = self.get_guess
    target_cell = get_cell(target[0], target[1])
    if target_cell.value != "_"
      puts "Error! That space is taken."
      set_cell(new_value)
    elsif floating_cell?(target[0], target[1])
      puts "Error! You must make your move either:\n- In the bottom row\n- Or on top of an already filled space"
      set_cell(new_value)
    else
      target_cell.value = new_value
    end
  end

  def get_guess
    puts "Choose X coordinate:"
    x = gets.chomp.to_i
    puts "Choose Y coordinate:"
    y = gets.chomp.to_i
    [x, y]
  end

  def display_grid
    @grid.each do |row|
      puts row.map { |cell| cell.value }.join(" | ")
    end
  end

  def game_over?
    return :winner if winner?
    return :draw if draw?
    false
  end

  private

  def winner?
    winning_values.any? { |row| row.uniq.count <= 1 && row.none? { |cell| cell == "_" } }
  end

  def draw?
    winning_values.none? { |row| row.any? { |cell| cell == "_"} }
  end

  def winning_values
    output = []

    self.winning_rows.each do |row|
      row_values = row.map { |cell| cell.value }
      output << row_values
    end

    self.winning_columns.each do |column|
      column_values = column.map { |cell| cell.value }
      output << column_values
    end

    self.diagonals.each do |diagonal|
      diagonal_values = diagonal.map { |cell| cell.value }
      output << diagonal_values
    end

    output
  end

  def winning_rows
    [
      grid[0][0..3], grid[0][1..4], grid[0][2..5], grid[0][3..6],
      grid[1][0..3], grid[1][1..4], grid[1][2..5], grid[1][3..6],
      grid[2][0..3], grid[2][1..4], grid[2][2..5], grid[2][3..6],
      grid[3][0..3], grid[3][1..4], grid[3][2..5], grid[3][3..6],
      grid[4][0..3], grid[4][1..4], grid[4][2..5], grid[4][3..6],
      grid[5][0..3], grid[5][1..4], grid[5][2..5], grid[5][3..6]
    ]
  end

  def winning_columns
    [
      [ grid[5][0], grid[4][0], grid[3][0], grid[2][0] ],
      [ grid[4][0], grid[3][0], grid[2][0], grid[1][0] ],
      [ grid[3][0], grid[2][0], grid[1][0], grid[0][0] ],
      [ grid[5][1], grid[4][1], grid[3][1], grid[2][1] ],
      [ grid[4][1], grid[3][1], grid[2][1], grid[1][1] ],
      [ grid[3][1], grid[2][1], grid[1][1], grid[0][1] ],
      [ grid[5][2], grid[4][2], grid[3][2], grid[2][2] ],
      [ grid[4][2], grid[3][2], grid[2][2], grid[1][2] ],
      [ grid[3][2], grid[2][2], grid[1][2], grid[0][2] ],
      [ grid[5][3], grid[4][3], grid[3][3], grid[2][3] ],
      [ grid[4][3], grid[3][3], grid[2][3], grid[1][3] ],
      [ grid[3][3], grid[2][3], grid[1][3], grid[0][3] ],
      [ grid[5][4], grid[4][4], grid[3][4], grid[2][4] ],
      [ grid[4][4], grid[3][4], grid[2][4], grid[1][4] ],
      [ grid[3][4], grid[2][4], grid[1][4], grid[0][4] ],
      [ grid[5][5], grid[4][5], grid[3][5], grid[2][5] ],
      [ grid[4][5], grid[3][5], grid[2][5], grid[1][5] ],
      [ grid[3][5], grid[2][5], grid[1][5], grid[0][5] ],
      [ grid[5][6], grid[4][6], grid[3][6], grid[2][6] ],
      [ grid[4][6], grid[3][6], grid[2][6], grid[1][6] ],
      [ grid[3][6], grid[2][6], grid[1][6], grid[0][6] ],
    ]
  end

  def diagonals
    [
      [ grid[2][0], grid[3][1], grid[4][2], grid[5][3] ],
      [ grid[1][0], grid[2][1], grid[3][2], grid[4][3] ],
      [ grid[0][0], grid[1][1], grid[2][2], grid[3][3] ],
      [ grid[2][1], grid[3][2], grid[4][3], grid[5][4] ],
      [ grid[1][1], grid[2][2], grid[3][3], grid[4][4] ],
      [ grid[0][1], grid[1][2], grid[2][3], grid[3][4] ],
      [ grid[2][2], grid[3][3], grid[4][4], grid[5][5] ],
      [ grid[1][2], grid[2][3], grid[3][4], grid[4][5] ],
      [ grid[0][2], grid[1][3], grid[2][4], grid[3][5] ],
      [ grid[2][3], grid[3][4], grid[4][5], grid[5][6] ],
      [ grid[1][3], grid[2][4], grid[3][5], grid[4][6] ],
      [ grid[0][3], grid[1][4], grid[2][5], grid[3][6] ],
      [ grid[3][0], grid[2][1], grid[1][2], grid[0][3] ],
      [ grid[4][0], grid[3][1], grid[2][2], grid[1][3] ],
      [ grid[5][0], grid[4][1], grid[3][2], grid[2][3] ],
      [ grid[3][1], grid[2][2], grid[1][3], grid[0][4] ],
      [ grid[4][1], grid[3][2], grid[2][3], grid[1][4] ],
      [ grid[5][1], grid[4][2], grid[3][3], grid[2][4] ],
      [ grid[3][2], grid[2][3], grid[1][4], grid[0][5] ],
      [ grid[4][2], grid[3][3], grid[2][4], grid[1][5] ],
      [ grid[5][2], grid[4][3], grid[3][4], grid[2][5] ],
      [ grid[3][3], grid[2][4], grid[1][5], grid[0][6] ],
      [ grid[4][3], grid[3][4], grid[2][5], grid[1][6] ],
      [ grid[5][3], grid[4][4], grid[3][5], grid[2][6] ],
    ]
  end

  def floating_cell?(x, y)
    if y > 0 && get_cell(x, y - 1).value == "_"
      true
    else
      false
    end
  end

  def invert_y(y)
    # This makes it so [0, 0] is in the bottom left corner of the grid
    5 - y
  end

  def default_grid
    Array.new(6) { Array.new(7) { Cell.new } }
  end
end

class Player
  attr_accessor :name, :marker
  def initialize
    @name = ""
    @marker = ""
  end

  def collect_name
    @name = gets.chomp
  end

  def collect_marker
    @marker = gets.chomp
  end
end

class Cell
  attr_accessor :value
  def initialize(value = "_")
    @value = value
  end
end