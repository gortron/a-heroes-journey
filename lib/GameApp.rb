class GameApp # This class acts as our frontend. Its only job is to ineract with user input/output.
  
  def main_menu
    # Main Menu presents the user with application options. User should be able to start new, load previous, save current, exit app, and see the leaderboard.

    puts "Welcome to A Hero's Journeys"

    selection = TTY::Prompt.new.select("Main Menu (type your selection in terminal):", %w(New\ Game Load\ Game Save\ Game Exit\ Game Leaderboard),cycle: true)
    # #puts "Main Menu (type your selection in terminal):\n
    # "New Game\n
    # Load Game\n
    # Save Game\n
    # Exit Game\n
    # Leaderboard"
    # menu_choice = gets.chomp

    case selection
    when "New Game"
      new_game
    when "Load Game"
      load_game
    when "Save Game"
      save_game
    when "Exit Game"
      exit_game
    when "Leaderboard"
      leader_board
    # else
    #   puts "Sorry, that isn't an option."
    #   main_menu
    end

  end
  
  def new_game
    # This needs a refactor... this should be defined in class Hero
    puts "What do they call you, hero?"
    name = gets.chomp
    puts "Name is #{name}"
    Hero.new({name: name})
    if Challenge.all.length == 0
      Challenge.seed_challenges
    end
    current_game
  end

  def current_game
    puts "Current Game Triggered"
    puts "Hero is #{Hero.last.name} with #{Hero.last.experience} experience and #{Hero.last.current_health} health."
    selection = TTY::Prompt.new.select("What will you do now?", %w(Journey Back\ to\ Main\ Menu), cycle: true)
    # puts "What will you do now?"
    # puts "Journey\n
    # Back to Main Menu"
    # game_choice = gets.chomp
    case selection
    when "Journey"
      enter_journey
    when "Back to Main Menu"
      main_menu
    # else
    #   puts "Sorry, that isn't an option."
    #   current_game
    end
  end

  def enter_journey
    puts "Enter Journey triggered"
    if Hero.last.current_health >= 0
      Journey.new_journey(self)
    else
      puts "Hero has perished! You must start a new game." 
      main_menu
    end
  end

  def journey_turn
    turn_choice = TTY::Prompt.new.select("What will you do now?", %w(Fight Flee), cycle: true)
    # puts "What will you do now?"
    # puts "Fight\n
    # Flee"
    # turn_choice = gets.chomp
    #binding.pry
    Journey.last.journey_turn_choice(self, turn_choice)
  end

  def load_game
    puts "Load Game triggered"
    if Hero.last.current_health > 0
      current_game
    else
      puts "Hero has perished! You must start a new game." 
      main_menu
    end
  end

  def save_game
    # I think the game auto-saves?
    puts "Save Game triggered"
    main_menu
  end

  def exit_game
    puts "Exit Game triggered"
    exit
  end

  def game_over
    puts "Game Over! #{Hero.all.last.name} has perished."
    main_menu
  end

  def leader_board
    # This should return the names of the five heroes with the longest runs (most experience), and their count.
    puts "Leader Board triggered"
    Hero.all.order('experience DESC').limit(5).each do |hero|
      puts "Name: #{hero.name}, Experience: #{hero.experience}"
    end
    main_menu
  end

end