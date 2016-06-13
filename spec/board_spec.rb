require 'bv_ttt'

RSpec.describe Board do
  before(:each) do
    @game = Game.new
  end

  context "draw_board" do
    it "draws a 3x3 board" do
      BOARD_SIZE = 3
      expect(@game.board.draw_board).to eql(3)
    end
  end
end
