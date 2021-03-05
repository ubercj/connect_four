require './lib/connect_four'

# 1. Command Method -> Test the change in the observable state
# 2. Query Method -> Test the return value
# 3. Method with Outgoing Command -> Test that a message is sent
# 4. Looping Script Method -> Test the behavior of the method

describe Game do
  
  describe "#play" do
    context "when stubbing game_over?"
      context "when the game has been won" do
        subject(:won_game) { described_class.new(dummy_board) }
        let(:dummy_board) { instance_double(Board) }
        let(:dummy_player) { instance_double(Player, name: "Joey") }

        before do
          allow($stdout).to receive(:write)
          allow(won_game).to receive(:puts).exactly(4).times
          allow(dummy_board).to receive(:display_grid)
          allow(dummy_board).to receive(:set_cell)
          allow(dummy_player).to receive(:marker)
          allow(dummy_board).to receive(:game_over?).and_return(:winner)
        end

        it "puts the victory message" do
          won_game.current_player = dummy_player
          victory_message = "Joey wins!"
          expect(won_game).to receive(:puts).with(victory_message)
          won_game.play
        end
      end

      context "when the game is a draw" do
        subject(:draw_game) { described_class.new(dummy_board) }
        let(:dummy_board) { instance_double(Board) }
        let(:dummy_player) { instance_double(Player, name: "Joey") }

        before do
          allow($stdout).to receive(:write)
          allow(draw_game).to receive(:puts).exactly(4).times
          allow(dummy_board).to receive(:display_grid)
          allow(dummy_board).to receive(:set_cell)
          allow(dummy_player).to receive(:marker)
          allow(dummy_board).to receive(:game_over?).and_return(:draw)
        end

        it "puts the tie message" do
          draw_message = "It's a tie!"
          expect(draw_game).to receive(:puts).with(draw_message)
          draw_game.play
        end
      end

      context "when there is no winner or draw" do
        subject(:dummy_game) { described_class.new(dummy_board) }
        let(:dummy_board) { instance_double(Board) }
        let(:dummy_player) { instance_double(Player, name: "Joey") }

        before do
          allow($stdout).to receive(:write)
          allow(dummy_game).to receive(:puts).exactly(3).times
          allow(dummy_board).to receive(:display_grid)
          allow(dummy_board).to receive(:set_cell)
          allow(dummy_player).to receive(:marker)
          allow(dummy_board).to receive(:game_over?).and_return(false, :winner)
        end

        context "when the game ends on the next turn" do
          it "loops one time and then stops" do
            dummy_game.current_player = dummy_player
            expect(dummy_game).to receive(:puts).exactly(3).times
            dummy_game.play
          end
        end
      end

    context "when NOT stubbing game_over?" do
      subject(:won_game) { described_class.new }
      let(:dummy_player) { instance_double(Player, name: "Joey") }

      context "when a row has connect four" do
        before do
          allow($stdout).to receive(:write)
          won_game.board.set_cell("$", [0, 0])
          won_game.board.set_cell("$", [1, 0])
          won_game.board.set_cell("$", [2, 0])
          won_game.board.set_cell("$", [3, 0])
          allow(dummy_board).to receive(:set_cell)
          allow(won_game).to receive(:puts).exactly(2).times
          allow(dummy_player).to receive(:marker)
        end

        xit "puts the victory message" do
          won_game.current_player = dummy_player
          victory_message = "Joey wins!"
          expect(won_game).to receive(:puts).with(victory_message)
          won_game.play
        end
      end

      context "when a column has connect four" do
        before do
          allow($stdout).to receive(:write)
          won_game.board.set_cell(0, 0, "$")
          won_game.board.set_cell(0, 1, "$")
          won_game.board.set_cell(0, 2, "$")
          won_game.board.set_cell(0, 3, "$")
          allow(won_game).to receive(:puts).exactly(4).times
          allow(dummy_player).to receive(:marker)
        end

        xit "puts the victory message" do
          won_game.current_player = dummy_player
          victory_message = "Joey wins!"
          expect(won_game).to receive(:puts).with(victory_message)
          won_game.play
        end
      end

      context "when a diagonal has connect four" do
        before do
          allow($stdout).to receive(:write)
          won_game.board.set_cell(0, 0, "$")
          won_game.board.set_cell(1, 0, "*")
          won_game.board.set_cell(1, 1, "$")
          won_game.board.set_cell(2, 0, "*")
          won_game.board.set_cell(2, 1, "*")
          won_game.board.set_cell(2, 2, "$")
          won_game.board.set_cell(3, 0, "*")
          won_game.board.set_cell(3, 1, "*")
          won_game.board.set_cell(3, 2, "*")
          won_game.board.set_cell(3, 3, "$")
          allow(won_game).to receive(:puts).exactly(4).times
          allow(dummy_player).to receive(:marker)
        end

        xit "puts the victory message" do
          won_game.current_player = dummy_player
          victory_message = "Joey wins!"
          expect(won_game).to receive(:puts).with(victory_message)
          won_game.play
        end
      end

      context "when the board is full, but nobody got connect four" do
        tie_grid = Array.new(6) { Array.new(7) { Cell.new("#{rand(0..100000)}")}}

        # There is a VERY small chance that this test will fail purely by chance,
        # but I couldn't think of a better way to fill the board with differing
        # values without taking a ton of time and effort

        tie_board = Board.new(tie_grid)
        subject(:draw_game) { described_class.new(tie_board) }
        
        before do
          allow($stdout).to receive(:write)
          allow(draw_game).to receive(:puts).exactly(4).times
          allow(dummy_player).to receive(:marker)
        end

        xit "puts the draw message" do
          draw_game.current_player = dummy_player
          draw_message = "It's a tie!"
          expect(draw_game).to receive(:puts).with(draw_message)
          draw_game.play
        end
      end

      context "when the board is blank" do
        before do
          allow($stdout).to receive(:write)
          allow(won_game).to receive(:loop).and_yield
          allow(won_game).to receive(:puts).exactly(4).times
          allow(dummy_player).to receive(:marker)
        end

        xit "does NOT puts the victory message" do
          won_game.current_player = dummy_player
          victory_message = "Joey wins!"
          expect(won_game).not_to receive(:puts).with(victory_message)
          won_game.play
        end
      end
    end
  end
end

describe Board do
  describe "#get_cell" do
    context "when the cell being tested is blank" do
      subject(:dummy_board) { described_class.new }
      it "returns cell with value = empty string" do
        result = dummy_board.get_cell(3, 4).value
        expect(result).to eq("_")
      end
    end

    context "when the cell being tested is filled" do
      filled_grid = Array.new(6) { Array.new(7) { Cell.new("$") } }
      subject(:dummy_board) { described_class.new(filled_grid)}
      it "returns a cell with value = a marker" do
        result = dummy_board.get_cell(3, 4).value
        expect(result).to eq("$")
      end
    end
  end

  describe "#set_cell" do
    context "when the target cell is blank" do
      subject(:dummy_board) { described_class.new }
      it "changes the value of the cell" do
        allow(dummy_board).to receive(:get_guess).and_return([0, 0])
        dummy_board.set_cell("%")
        value = dummy_board.get_cell(0, 0).value
        expect(value).to eq("%")
      end
    end

    context "when the target cell is already filled" do
      filled_grid = Array.new(6) { Array.new(7) { Cell.new("$") } }
      subject(:dummy_board) { described_class.new(filled_grid) }
      xit "puts an error message" do
        allow(dummy_board).to receive(:get_guess).and_return([3, 4])
        # dummy_board.set_cell("%")
        error_message = "Error! That space is taken."
        expect { dummy_board.set_cell("%") }.to output(error_message).to_stdout
        # expect(dummy_board).to receive(:puts).with(error_message)
      end

      xit "doesn't change the value of the already filled cell" do
        allow(dummy_board).to receive(:set_cell).once
        allow(dummy_board).to receive(:get_guess).and_return([3, 4])
        dummy_board.set_cell("%")
        value = dummy_board.get_cell(3, 4).value
        expect(value).to eq("$")
      end
    end

    context "when the cell beneath the target cell is empty" do
      subject(:dummy_board) { described_class.new }
      xit "returns an error message" do
        allow(dummy_board).to receive(:set_cell).once
        allow(dummy_board).to receive(:get_guess).and_return([1, 1])
        dummy_board.set_cell("#")
        error_message = "Error! You must make your move either:\n- In the bottom row\n- Or on top of an already filled space"
        expect(dummy_board).to receive(:puts).with(error_message)
      end
    end
  end
end

describe Player do
  describe "#collect_name" do
    context "when John is playing with a $ marker" do
    subject(:john) { described_class.new }
      
      it "updates player.name to John" do
        allow(john).to receive(:gets).and_return("John")
        john.collect_name
        expect(john.name).to eq("John")
      end

      it "updates player.marker to $" do
        allow(john).to receive(:gets).and_return("$")
        john.collect_marker
        expect(john.marker).to eq("$")
      end
    end
  end
end