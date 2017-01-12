#classes: board, player?, row?
#board elements:
#rows
#solution

class Board
  attr_accessor :solution, :row_width, :num_rows
  def initialize(num_rows=12)
    puts "What should the solution be? The colors are R, G, B, Y, W, P"
    @solution = gets.chomp
    @row_width = @solution.length
    @num_rows = num_rows

    main_loop
  end

  def compare(guess)
    guess.upcase!
    unless guess.length == @solution.length and guess.length == @row_width
      return false
    end
    white_count = 0
    black_count = 0
    colors = Hash.new('none')

    @solution.length.times do |c|
      col = guess[c]
      if @solution[c] == guess[c]
        if colors[col] != 'white'
          white_count += 1
        end
        if colors[col] == 'black'
          black_count -= 1
        end
        colors[col] = 'white'
      elsif @solution.include? guess[c]
        if colors[col] == 'none'
          black_count += 1
          colors[col] = 'black'
        end
      end
    end
    [black_count, white_count]
  end

  def main_loop
    loop do
      if @num_rows <= 0
        puts "The solution was not guessed correctly."
        return false
      else
        puts "You have #{@num_rows} guesses remaining. Please enter your guess."
        guess = gets.chomp
        results = compare(guess)
        if results != false
          if results[1] < @row_width
            puts "#{results[0]} color(s) were in the solution but placed incorrectly."
            puts "#{results[1]} color(s) were in the correct place."
            @num_rows -= 1
          else
            puts "You won the game in #{@num_rows} guesses!"
            return true
          end
        else
          puts "Please enter a valid guess."
        end
      end
    end
  end

end
