class Game
  attr_accessor :board, :current_player, :other_player
  def initialize(board = Board.new)
    @board = board
    players = Array.new(2) { Player.new }
    @current_player, @other_player = players.shuffle
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
  
  def play
    get_players(@current_player, @other_player)
    loop do
      board.display_grid
      puts "It's #{@current_player.name}'s turn to pick a space."
      board.set_cell(@current_player.marker)
      if board.game_over?
        endgame_message
        board.display_grid
        return
      else
        switch_players
      end
    end
  end

  def endgame_message
    puts "#{@current_player.name} wins!" if board.game_over? == :winner
    puts "It's a tie!" if board.game_over? == :draw
  end

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

end