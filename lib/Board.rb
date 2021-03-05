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
    bad_target = invalid_target?(target_cell, target[0], target[1])
    if bad_target
      set_error(bad_target)
      set_cell(new_value)
    else
      target_cell.value = new_value
    end
  end
  
  def get_guess
    puts "Choose X coordinate:"
    x = self.x_coordinate_input
    puts "Choose Y coordinate:"
    y = self.y_coordinate_input
    [x, y]
  end

  def x_coordinate_input
    input = gets.chomp
    return input.to_i if input.match?(/^[0-6]$/)
    puts "Coordinate must be an integer between 0 and 6."
    self.x_coordinate_input
  end

  def y_coordinate_input
    input = gets.chomp
    return input.to_i if input.match?(/^[0-5]$/)
    puts "Coordinate must be an integer between 0 and 5."
    self.y_coordinate_input
  end

  def invalid_target?(target_cell, x, y)
    return :full if empty_cell?(target_cell) == false
    return :floating if floating_cell?(x, y)
    false
  end

  def empty_cell?(target_cell)
    return false if target_cell.value != "_"
    true
  end
  
  def floating_cell?(x, y)
    return true if y > 0 && get_cell(x, y - 1).value == "_"
    false
  end
  
  def set_error(bad_target)
    puts "Error! That space is taken." if bad_target == :full
    puts "Error! You must make your move either:\n- In the bottom row\n- Or on top of an already filled space" if bad_target == :floating
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
  
  def winner?
    winning_values.any? { |row| row.uniq.count <= 1 && row.none? { |cell| cell == "_" } }
  end
  
  def draw?
    winning_values.none? { |row| row.any? { |cell| cell == "_"} }
  end
  
  private

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

  def invert_y(y)
    # This makes it so [0, 0] is in the bottom left corner of the grid
    5 - y
  end

  def default_grid
    Array.new(6) { Array.new(7) { Cell.new } }
  end
end