require 'bv_ttt'

RSpec.describe Player do
  before(:each) do
    @game = Game.new
  end

  context "ask_for_first_player" do
    it "makes human first player if user responds accordingly" do
      allow(STDIN).to receive(:gets) { "y" }
      answer = @game.human.ask_for_first_player
      expect(answer).to eql("first")
    end

    it "makes human second player if user responds accordingly" do
      allow(STDIN).to receive(:gets) { "n" }
      answer = @game.human.ask_for_first_player
      expect(answer).to eql(nil)
    end
  end
end
