require './lib/Game'
require './lib/Board'
require './lib/Player'
require './lib/Cell'

# 1. Command Method -> Test the change in the observable state
# 2. Query Method -> Test the return value
# 3. Method with Outgoing Command -> Test that a message is sent
# 4. Looping Script Method -> Test the behavior of the method

describe Game do
  describe "#initialize" do
    # Do not have to test #initialize if it is only creating instance variables.
    #Also, #shuffle is a well-tested array method in Ruby
  end

  describe "#get_players" do
    # Method with Outgoing Command -> Test that a message is sent
    subject(:test_game) { described_class.new(dummy_board) }
    let(:dummy_board) { instance_double(Board) }
    let(:player1) { instance_double(Player) }
    let(:player2) { instance_double(Player) }

    context "when method is called" do
      before do
        allow($stdout).to receive(:write)
        allow(player1).to receive(:collect_marker)
        allow(player2).to receive(:collect_name)
        allow(player2).to receive(:collect_marker)
      end

      it "sends #collect_name to player1" do
        expect(player1).to receive(:collect_name)
        test_game.get_players(player1, player2)
      end

      before do
        allow($stdout).to receive(:write)
        allow(player1).to receive(:collect_name)
        allow(player2).to receive(:collect_name)
        allow(player2).to receive(:collect_marker)
      end

      it "sends #collect_marker to player1" do
        expect(player1).to receive(:collect_marker)
        test_game.get_players(player1, player2)
      end

      before do
        allow($stdout).to receive(:write)
        allow(player1).to receive(:collect_name)
        allow(player2).to receive(:collect_name)
        allow(player2).to receive(:collect_marker)
      end

      it "sends #collect_name to player2" do
        expect(player2).to receive(:collect_name)
        test_game.get_players(player1, player2)
      end

      before do
        allow($stdout).to receive(:write)
        allow(player1).to receive(:collect_name)
        allow(player2).to receive(:collect_name)
        allow(player2).to receive(:collect_marker)
      end

      it "sends #collect_marker to player2" do
        expect(player2).to receive(:collect_marker)
        test_game.get_players(player1, player2)
      end
    end
  end

  describe "#play" do
    # Looping Script Method -> Test the behavior of the method
    subject(:test_game) { described_class.new(dummy_board) }
    let(:dummy_board) { instance_double(Board) }
    let(:player1) { instance_double(Player, { name: "Joey", marker: "$" }) }
    let(:player2) { instance_double(Player, { name: "Lisa", marker: "%"}) }

    context "when game is over" do
      before do
        allow($stdout).to receive(:write)
        allow(test_game).to receive(:get_players)
        allow(dummy_board).to receive(:display_grid)
        allow(dummy_board).to receive(:set_cell)
        allow(dummy_board).to receive(:game_over?).and_return(:winner)
      end

      it "calls the endgame_message method" do
        test_game.current_player = player1
        expect(test_game).to receive(:endgame_message).once
        test_game.play
      end
    end

    context "when game is not over, but ends in 1 turn" do
      before do
        allow($stdout).to receive(:write)
        allow(test_game).to receive(:get_players)
        allow(dummy_board).to receive(:display_grid)
        allow(dummy_board).to receive(:set_cell)
        allow(dummy_board).to receive(:game_over?).and_return(false, :winner)
      end

      it "switches players exactly once" do
        test_game.current_player = player1
        expect(test_game).to receive(:switch_players).once
        test_game.play
      end
    end

    context "when game is not over, but ends in 5 turns" do
      before do
        allow($stdout).to receive(:write)
        allow(test_game).to receive(:get_players)
        allow(dummy_board).to receive(:display_grid)
        allow(dummy_board).to receive(:set_cell)
        allow(dummy_board).to receive(:game_over?).and_return(false, false, false, false, false, :winner)
      end

      it "switches players exactly 5 times" do
        test_game.current_player = player1
        expect(test_game).to receive(:switch_players).exactly(5).times
        test_game.play
      end
    end
  end

  describe "#endgame_message" do
    # No need to test methods that only contain 'puts' or 'gets' 
    # because they are well-tested in the standard Ruby library.
  end

  describe "#switch_players" do
    # Command Method -> Test the change in the observable state
    context "when method is called" do
      subject(:test_game) { described_class.new(dummy_board) }
      let(:dummy_board) { instance_double(Board) }
      let(:player1) { instance_double(Player) }
      let(:player2) { instance_double(Player) }

      it "changes player1 from @current_player to @other_player" do
        allow($stdout).to receive(:write)
        test_game.current_player = player1
        test_game.other_player = player2
        test_game.switch_players
        expect(test_game.other_player).to eq(player1)
      end
    end
  end

end

describe Board do
  # Do not have to test #initialize if it is only creating instance variables.
  describe "#get_cell" do
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when called on an empty cell" do
      it "returns empty value" do
        result = test_board.get_cell(3, 0).value
        expect(result).to eq("_")
      end
    end

    context "when called on a filled cell" do
      it "returns the marker in the cell" do
        test_board.grid[5][0].value = "$"
        result = test_board.get_cell(0, 0).value
        expect(result).to eq("$")
      end
    end
  end

  describe "#set_cell" do
    # Public Script Method
    subject(:test_board) { described_class.new }
    
    context "when player enters a good target cell" do
      # Command Method -> Test the change in the observable state
      before do
        target_cell = test_board.grid[5][2]
        allow(test_board).to receive(:get_guess).and_return([2, 0])
        allow(test_board).to receive(:get_cell).and_return(target_cell)
        allow(test_board).to receive(:invalid_target?).and_return(false)
      end

      it "changes the value of the target cell" do
        target_cell = test_board.grid[5][2]
        test_board.set_cell("$")
        expect(target_cell.value).to eq("$")
      end
    end

    context "when player enters a good target cell" do
      # Recursive Method -> Test that it stops when conditions are met
      before do
        target_cell = test_board.grid[5][2]
        allow(test_board).to receive(:get_guess).and_return([2, 0])
        allow(test_board).to receive(:get_cell).and_return(target_cell)
        allow(test_board).to receive(:invalid_target?).and_return(:full, false)
        allow(test_board).to receive(:set_error)
      end

      it "changes the value of the target cell" do
        expect(test_board).to receive(:set_error).once
        test_board.set_cell("$")
      end
    end

  end

  describe "get_guess" do
    # Query Method -> Test the return value
    # Also a Script Method (?) located inside #set_cell
    subject(:test_board) { described_class.new }

    context "when given valid inputs" do
      before do
        allow($stdout).to receive(:write)
        allow(test_board).to receive(:puts).twice  
        allow(test_board).to receive(:x_coordinate_input).and_return(3)
        allow(test_board).to receive(:y_coordinate_input).and_return(4)
      end

      it "returns a proper array" do
        result = test_board.get_guess
        expect(result).to eq([3, 4])
      end
    end
  end

  describe "#x_coordinate_input" do
    # Located inside #get_guess (Script Method)
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when given a valid input" do
      it "returns the value" do
        allow(test_board).to receive(:gets).and_return('3')
        value = test_board.x_coordinate_input
        expect(value).to eq(3)
      end
    end

    context "when given a number outside the acceptable range" do
      # Recursive Method -> Test that it stops when conditions are met
      before do
        allow(test_board).to receive(:gets).and_return('32', '4')
      end

      it "puts an error message, then stops with valid input" do
        error_message = "Coordinate must be an integer between 0 and 6.\n"
        expect { test_board.x_coordinate_input }.to output(error_message).to_stdout
      end
    end

    context "when given something that is not a number" do
      before do
        allow(test_board).to receive(:gets).and_return('hey', '4')
      end

      it "puts an error message, then stops with valid input" do
        error_message = "Coordinate must be an integer between 0 and 6.\n"
        expect { test_board.x_coordinate_input }.to output(error_message).to_stdout
      end
    end
  end

  describe "#y_coordinate_input" do
    # Essentially identical to #x_coordinate_input
    # Located inside #get_guess (Script Method)
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when given a valid input" do
      it "returns the value" do
        allow(test_board).to receive(:gets).and_return('3')
        value = test_board.y_coordinate_input
        expect(value).to eq(3)
      end
    end

    context "when given a number outside the acceptable range" do
      # Recursive Method -> Test that it stops when conditions are met
      before do
        allow(test_board).to receive(:gets).and_return('32', '4')
      end

      it "puts an error message, then stops with valid input" do
        error_message = "Coordinate must be an integer between 0 and 5.\n"
        expect { test_board.y_coordinate_input }.to output(error_message).to_stdout
      end
    end

    context "when given something that is not a number" do
      before do
        allow(test_board).to receive(:gets).and_return('hey', '4')
      end

      it "puts an error message, then stops with valid input" do
        error_message = "Coordinate must be an integer between 0 and 5.\n"
        expect { test_board.y_coordinate_input }.to output(error_message).to_stdout
      end
    end
  end

  describe "#invalid_target?" do
    # Located inside #set_cell
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when target is valid" do
      before do
        allow(test_board).to receive(:empty_cell?).and_return(true)
        allow(test_board).to receive(:floating_cell?).and_return(false)
      end

      it "returns false" do
        target_cell = test_board.grid[5][1]
        x = 1
        y = 0
        result = test_board.invalid_target?(target_cell, x, y)
        expect(result).to be false
      end
    end

    context "when target is already filled" do
      before do
        allow(test_board).to receive(:empty_cell?).and_return(false)
        allow(test_board).to receive(:floating_cell?).and_return(false)
      end

      it "returns :full" do
        target_cell = test_board.grid[5][1]
        x = 1
        y = 0
        result = test_board.invalid_target?(target_cell, x, y)
        expect(result).to eq(:full)
      end
    end

    context "when target is floating cell" do
      before do
        allow(test_board).to receive(:empty_cell?).and_return(true)
        allow(test_board).to receive(:floating_cell?).and_return(true)
      end

      it "returns :floating" do
        target_cell = test_board.grid[5][1]
        x = 1
        y = 0
        result = test_board.invalid_target?(target_cell, x, y)
        expect(result).to eq(:floating)
      end
    end
  end

  describe "#empty_cell?" do
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when passed an empty cell" do
      it "returns true" do
        target_cell = test_board.grid[5][1]
        result = test_board.empty_cell?(target_cell)
        expect(result).to be true        
      end
    end

    context "when passed a filled cell" do
      it "returns false" do
        target_cell = test_board.grid[5][1]
        target_cell.value = "$"
        result = test_board.empty_cell?(target_cell)
        expect(result).to be false
      end
    end
  end

  describe "#floating_cell?" do
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when passed a floating cell" do
      it "returns true" do
        x = 3
        y = 1
        result = test_board.floating_cell?(x, y)
        expect(result).to be true
      end
    end

    context "when passed a cell that is not floating" do
      it "returns false" do
        x = 3
        y = 0
        result = test_board.floating_cell?(x, y)
        expect(result).to be false
      end
    end
  end

  describe "#set_error" do
    # Test that the correct error message is printed to console
    subject(:test_board) { described_class.new }

    context "when passed a target cell that has already been filled" do
      it "puts the correct error message" do
        bad_target = :full
        error_message = "Error! That space is taken.\n"
        expect { test_board.set_error(bad_target) }.to output(error_message).to_stdout
      end
    end

    context "when passed a target cell that is floating" do
      it "puts the correct error message" do
        bad_target = :floating
        error_message = "Error! You must make your move either:\n- In the bottom row\n- Or on top of an already filled space\n"
        expect { test_board.set_error(bad_target) }.to output(error_message).to_stdout
      end
    end
  end

  describe "#display_grid" do
    # Do not have to test methods that only contain 'puts' or 'gets'
    # because they are well-tested in the standard Ruby library.
  end

  describe "#game_over?" do
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when there is a winner" do
      it "returns :winner" do
        allow(test_board).to receive(:winner?).and_return(true)
        result = test_board.game_over?
        expect(result).to eq(:winner)
      end
    end

    context "when there is a draw" do
      it "returns :draw" do
        allow(test_board).to receive(:winner?).and_return(false)
        allow(test_board).to receive(:draw?).and_return(true)
        result = test_board.game_over?
        expect(result).to eq(:draw)
      end
    end

    context "when there is no winner and no draw" do
      it "returns false" do
        allow(test_board).to receive(:winner?).and_return(false)
        allow(test_board).to receive(:draw?).and_return(false)
        result = test_board.game_over?
        expect(result).to be false
      end
    end
  end

  describe "#winner?" do
    # Query Method -> Test the return value
    subject(:test_board) { described_class.new }

    context "when there are 4 cells with identical values in a row" do
      before do
        test_board.grid[5][0].value = "$"
        test_board.grid[5][1].value = "$"
        test_board.grid[5][2].value = "$"
        test_board.grid[5][3].value = "$"
      end

      it "returns true" do
        result = test_board.winner?
        expect(result).to be true
      end
    end

    context "when there are 4 cells with identical values in a column" do
      before do
        test_board.grid[5][0].value = "$"
        test_board.grid[4][0].value = "$"
        test_board.grid[3][0].value = "$"
        test_board.grid[2][0].value = "$"
      end

      it "returns true" do
        result = test_board.winner?
        expect(result).to be true
      end
    end

    context "when there are 4 cells with identical values in a diagonal" do
      before do
        test_board.grid[5][0].value = "$"
        test_board.grid[4][1].value = "$"
        test_board.grid[3][2].value = "$"
        test_board.grid[2][3].value = "$"
      end

      it "returns true" do
        result = test_board.winner?
        expect(result).to be true
      end
    end

    context "when there is no winner" do
      it "returns false" do
        result = test_board.winner?
        expect(result).to be false
      end
    end
  end

  describe "#draw?" do
    # Query Method -> Test the return value

    context "when the board is completely filled and there is no winner" do
      filled_grid = Array.new(6) { Array.new(7) { Cell.new("$") } }
      # This completely fills the grid, and pretends that #winner? would be false
      subject(:test_board) { described_class.new(filled_grid) }

      it "returns true" do
        result = test_board.draw?
        expect(result).to be true
      end
    end

    context "when the board is not full" do
      subject(:test_board) { described_class.new }

      it "returns false" do
        result = test_board.draw?
        expect(result).to be false
      end
    end
  end
end

describe Player do
  # Do not have to test #initialize if it is only creating instance
  # variables.
  describe '#collect_name' do
    # Do not have to test methods that only contain 'puts' or 'gets'
    # because they are well-tested in the standard Ruby library.  
  end
  
  describe '#collect_marker' do
    # Do not have to test methods that only contain 'puts' or 'gets'
    # because they are well-tested in the standard Ruby library.  
  end       
end

describe Cell do
  # Do not have to test #initialize if it is only creating instance
  # variables.
end