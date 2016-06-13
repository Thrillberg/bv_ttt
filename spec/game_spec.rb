require 'bv_ttt'

RSpec.describe Game do
  before(:each) do
    @game = Game.new
  end

  context "determine_player_order" do
    it "makes human first player if user responds accordingly" do
      allow(STDIN).to receive(:gets) { "y" }
      @game.human.ask_for_first_player
      expect(@game.human.order).to eql('first')
    end
  end

  context "winner" do
    it "returns :human for a human win" do
      @game.board.grid[0][0] = "X"
      @game.board.grid[0][1] = "X"
      @game.board.grid[0][2] = "X"
      expect(@game.winner).to eql(:human)
    end

    it "returns :computer for a computer win" do
      @game.board.grid[0][0] = "O"
      @game.board.grid[1][1] = "O"
      @game.board.grid[2][2] = "O"
      expect(@game.winner).to eql(:computer)
    end
  end

  context "check_winning_combinations" do
    it "returns true for a human win" do
      @game.board.grid[0][0] = "X"
      @game.board.grid[0][1] = "X"
      @game.board.grid[0][2] = "X"
      squares = [[0,0], [0,1], [0,2]]
      expect(@game.check_winning_combinations(@game.human, squares, @game.board)).to eql(true)
    end
  end

  context "find_winning_move" do
    it "returns the winning move for computer" do
      @game.board.grid[0][0] = "O"
      @game.board.grid[1][1] = "O"
      squares = [[0,0], [1,1]]
      expect(@game.find_winning_move).to eql([2,2])
    end
  end
end
