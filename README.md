# README
--------

To run the game, go to the `lib` directory and enter `ruby bv_ttt.rb "play"`

The win detection algorithm is based on a loop on all of the given players moves on the board. From there, the program detects whether the correct adjacent squares (designated by row + 1, row + 2, etc.) have the given player's marker.

Bonuses:
- Grid size is variable
- RSpec testing (in root directory, run `rspec spec`)
- Computer will correctly select the 3rd move if it wins the game (this is accomplished by constructing a `@temporary_board`, a duplicate of the main board, and trying out all valid moves until one satisfies the win condition)
- Human can choose to randomize the starting player
