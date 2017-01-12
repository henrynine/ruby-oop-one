class Board
  @@size = 3

  def initialize


    @grid = Array.new
    @@size.times do |i|
      @grid << Array.new
      @@size.times do |j|
        @grid[i] << " "
      end
    end

    @players = Array.new
    puts "Welcome to Tic Tac Toe!"
    2.times do |i|
      @players << make_player(i)
    end
    puts "#{@players[0].name} will now play #{@players[1].name}."

    @active_player = @players[1]

    main_loop
  end

  def Board.print_break
    puts ''
    7.times {print '-'}
    puts ''
  end

  private

  def print_board
    Board.print_break
    @grid.each do |row|
      print '|'
      row.each do |square|
        print square + '|'
      end
      Board.print_break
    end
  end

  #private, don't do yet for testing purposes
  def is_valid?(coords)
    if !coords.all? {|s| s.to_i < @@size}
      return false
    elsif @grid[coords[0].to_i][coords[1].to_i] != ' '
      return false
    else
      true
    end
  end

  def place(coords, symbol)
    @grid[coords[0].to_i][coords[1].to_i] = symbol
  end

  def cycle_active_player
    @active_player = @players[(@players.index(@active_player)+1)%2]
  end

  def make_player(i)
    puts "Enter a name for Player #{i+1}"
    name = gets.chomp
    Player.new(name, i)
  end

  def grid_is_full?
    @grid.each do |row|
      row.each do |square|
        return false if square == ' '
      end
    end
    true
  end

  def row_win?
    @grid.each do |row|
      first_in_row = row[0]
      row_complete = first_in_row == ' ' ? false : true
      row.each do |square|
        row_complete = false if square != first_in_row
      end
      #print "Row: '#{row}' row_complete: #{row_complete} first_in_row: '#{first_in_row}'"
      return true if row_complete && first_in_row != ' '
    end
    false
  end

  def diagonal_win?
    top_left = @grid[0][0]
    bottom_left = @grid[2][0]
    if @grid[1][1] == top_left && @grid[2][2] == top_left
      return true unless top_left == ' '
    end
    if @grid[1][1] == bottom_left && @grid[0][2] == bottom_left
      return true unless bottom_left == ' '
    end
    false
  end

  def column_win?
    @@size.times do |c|
      first_in_col = @grid[0][c]
      col_complete = first_in_col == ' ' ? false : true
      @@size.times do |r|
        col_complete = false if @grid[r][c] != first_in_col
      end
      return true if col_complete && first_in_col != ' '
    end
    false
  end


  def game_over?
    #three in a row:
    #across each, down each, two diagonals
    #if full: draw
    winner = row_win? || diagonal_win? || column_win?

    return 1 if winner

    return 2 if grid_is_full?

    0

  end

  def main_loop
    loop do
      puts "Current board:"
      print_board
      game_state = game_over?

      if game_state == 1#winner found
        puts "#{@active_player.name} wins!"
        return 1
      elsif game_state == 2#draw
        puts "Draw!"
        return 1
      else
        #continue game
        cycle_active_player
        puts "It's time for #{@active_player.name} to play."
        loop do
          puts "Enter the square you want to play in like this: row, column: "
          coords = gets.chomp.strip.split(', ')
          if is_valid?(coords) == false
            puts "Enter a valid, unoccupied square"
          else
            place(coords, @active_player.symbol)
            break
          end
        end
      end
    end

  end

end

class Player

  attr_reader :name, :symbol

  def initialize(name, number)
    @name = name
    @symbol = number == 0 ? 'X' : 'O'
  end

end
