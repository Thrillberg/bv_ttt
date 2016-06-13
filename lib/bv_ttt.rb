BOARD_SIZE = 3

class Game
  attr_accessor :marker, :board, :temporary_board, :human, :computer

  def initialize
    @board = Board.new
    @temporary_board = Board.new
    @human = Player.new('X')
    @computer = Player.new('O')
  end

  def play
    determine_player_order
    alternate_turns
    announce_winner(winner)
    play_again?
  end

  def determine_player_order
    @human.ask_for_first_player
    if @human.order == 'first'
      @first_player = @human
      @second_player = @computer
    else
      @computer.order = 'second'
      @first_player = @computer
      @second_player = @human
    end
  end

  def alternate_turns
    until winner
      @board.draw_board
      turn(@board, @first_player)
      @board.draw_board
      break if winner
      turn(@board, @second_player)
      @board.draw_board
    end
  end

  def winner
    human_squares = get_occupied_squares(@human)
    computer_squares = get_occupied_squares(@computer)
    return :human if check_winning_combinations(@human, human_squares, @board)
    return :computer if check_winning_combinations(@computer, computer_squares, @board)
  end

  def get_occupied_squares(player)
    squares = []
    @board.grid.each_with_index do |row, row_index|
      row.each_with_index do |square, square_index|
        if square == player.marker
          squares << [row_index, square_index]
        end
      end
    end
    return squares
  end

  def get_marker(player)
    if player == @human
      return @human.marker
    else
      return @computer.marker
    end
  end

  def check_winning_combinations(player, squares, board)
    marker = get_marker(player)
    if squares.count >= 3
      squares.each do |square|
        row = square[0]
        column = square[1]
        # Horizontal win
        if column <= BOARD_SIZE - 3
          if board.grid[row][column + 1] == marker && board.grid[row][column + 2] == marker
            return true
          end
        end
        # Vertical win
        if row <= BOARD_SIZE - 3
          if board.grid[row + 1][column] == marker && board.grid[row + 2][column] == marker
            return true
          end
        end
        # Diagonal wins
        if column <= BOARD_SIZE - 3 && row <= BOARD_SIZE - 3
          if board.grid[row + 1][column + 1] == marker && board.grid[row + 2][column + 2] == marker
            return true
          end
        end
        if column <= BOARD_SIZE - 3 && row >= 2
          if board.grid[row - 1][column + 1] == marker && board.grid[row - 2][column + 2] == marker
            return true
          end
        end
      end
    end
    false
  end

  def turn(board, player)
    @marker = @computer.marker
    move = select_move(player)
    place_move(player, move)
  end

  def select_move(player)
    if player == @human
      @marker = @human.marker
      split_move = move_prompt.split(',')
      return [split_move[0].to_i, split_move[1].to_i]
    else
      return find_winning_move || [rand(0..BOARD_SIZE - 1), rand(0..BOARD_SIZE - 1)]
    end
  end

  def find_winning_move
    @temporary_board.grid = @board.grid.map { |array| array.dup }
    squares = get_occupied_squares(@computer)
    return try_temporary_moves(squares)
  end

  def get_legal_moves
    legal_moves = []
    total_occupied_squares = get_occupied_squares(@computer)
    total_occupied_squares += get_occupied_squares(@human)
    @temporary_board.grid.each_with_index do |row, row_index|
      row.each_with_index do |space, space_index|
        unless total_occupied_squares.include? [row_index, space_index]
          legal_moves << [row_index, space_index]
        end
      end
    end
    return legal_moves
  end

  def try_temporary_moves(squares)
    legal_moves = get_legal_moves
    legal_moves.each_with_index do |square, index|
      @temporary_board.grid[legal_moves[index][0]][legal_moves[index][1]] = @computer.marker
      squares << legal_moves[index]
      if check_winning_combinations(@computer, squares, @temporary_board)
        return [legal_moves[index][0], legal_moves[index][1]]
      end
      @temporary_board.grid[legal_moves[index][0]][legal_moves[index][1]] = ' '
      squares.delete legal_moves[index]
    end
    false
  end

  def place_move(player, move)
    if @board.grid[move[0]][move[1]] == ' '
      @board.grid[move[0]][move[1]] = player.marker
    else
      puts 'Sorry, please enter an empty square!'
      turn(board, player)
    end
  end

  def move_prompt
    puts 'Where would you like to move?'
    puts 'Please enter two numbers separated by a comma.'
    puts '(row first and then the column.)'
    STDIN.gets.chomp
  end

  def announce_winner(winner)
    if winner == :human
      puts 'Congratulations! You won.'
    elsif winner == :computer
      puts 'You were outsmarted by a computer. Sorry!'
    end
  end

  def play_again?
    puts 'Would you like to play again? (y/n)'
    play_again = STDIN.gets.chomp
    if play_again == 'y' || play_again == 'yes'
      system 'clear'
      Game.new.play
    elsif play_again == 'n' || play_again == 'no'
      puts 'See you next time!'
    end
  end
end

class Board
  attr_accessor :grid

  def initialize
    @grid = []
    BOARD_SIZE.times do
      row = []
      BOARD_SIZE.times do
        row << ' '
      end
      @grid << row
    end
  end

  def draw_board
    system 'clear'
    BOARD_SIZE.times do |row|
      board_line = ''
      BOARD_SIZE.times do |space|
        board_line.concat(" #{@grid[row][space]} |")
      end
      board_line.concat("\n")
      BOARD_SIZE.times do
        board_line.concat('----')
      end
      puts board_line
    end
  end
end

class Player
  attr_accessor :order, :marker

  def initialize(marker)
    @order = 'last'
    @marker = marker
  end

  def ask_for_first_player
    puts 'Would you like to go first? (y/n)'
    puts 'Or would you like first player to be randomly determined? (r)'
    answer = STDIN.gets.chomp
    if answer == 'y' || answer == 'yes'
      self.order = 'first'
    elsif answer == 'r' || answer == 'random'
      player = rand(2)
      player == 0 ? human_is_first : computer_is_first
    end
  end

  def human_is_first
    self.order = 'first'
    puts 'You got first player!'
    sleep(1)
  end

  def computer_is_first
    puts 'The computer is first player!'
    sleep(1)
  end
end

def bv_ttt(*args)
  Game.new.play if args == ["play"]
end

bv_ttt(*ARGV)
