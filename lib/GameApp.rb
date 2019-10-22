class GameApp # This class acts as our frontend. Its only job is to ineract with user input/output.

  @@prompt = TTY::Prompt.new

  @@header = "
  _______    __   __  _______  ______    _______  __   _______        ___  _______  __   __  ______    __    _  _______  __   __  _______ 
  |   _   |  |  | |  ||       ||    _ |  |       ||  | |       |      |   ||       ||  | |  ||    _ |  |  |  | ||       ||  | |  ||       |
  |  |_|  |  |  |_|  ||    ___||   | ||  |   _   ||__| |  _____|      |   ||   _   ||  | |  ||   | ||  |   |_| ||    ___||  |_|  ||  _____|
  |       |  |       ||   |___ |   |_||_ |  | |  |     | |_____       |   ||  | |  ||  |_|  ||   |_||_ |       ||   |___ |       || |_____ 
  |       |  |       ||    ___||    __  ||  |_|  |     |_____  |   ___|   ||  |_|  ||       ||    __  ||  _    ||    ___||_     _||_____  |
  |   _   |  |   _   ||   |___ |   |  | ||       |      _____| |  |       ||       ||       ||   |  | || | |   ||   |___   |   |   _____| |
  |__| |__|  |__| |__||_______||___|  |_||_______|     |_______|  |_______||_______||_______||___|  |_||_|  |__||_______|  |___|  |_______|
  "
  
  def main_menu
    # Main Menu presents the user with application options. User should be able to start new, load previous, save current, exit app, and see the leaderboard.
    display

    selection = @@prompt.select("Main Menu (type your selection in terminal):", %w(New\ Game Load\ Game Save\ Game Exit\ Game Leaderboard),cycle: true)

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
    end
  end
  
  def new_game
    display
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
    display
    #challenge.reset
    puts "Hero is #{Hero.last.name} with #{Hero.last.experience} experience and #{Hero.last.current_health} health."
    
    selection = @@prompt.select("What will you do now?", %w(Journey Back\ to\ Main\ Menu), cycle: true)

    case selection
    when "Journey"
      enter_journey
    when "Back to Main Menu"
      main_menu
    end
  end

  def enter_journey
    Journey.new_journey
    journey_turns
  end

  def journey_turns
    while hero.current_health > 0 && challenge.current_health > 0 
      turn_choice = @@prompt.select("What will you do now?", %w(Fight Flee), cycle: true)
      case turn_choice
      when "Fight"
        journey.fight
      when "Flee"
        puts "You fled!"
        challenge.reset
        current_game
      end
    end
    challenge.reset
    game_over if hero.current_health == 0
    current_game
  end

  def load_game
    if hero.current_health > 0
      current_game
    else
      game_over
    end
  end

  def save_game
    # I think the game auto-saves?
    main_menu
  end

  def exit_game
    exit
  end

  

  def leader_board
    # This should return the names of the five heroes with the longest runs (most experience), and their count.
    display
    Hero.all.order('experience DESC').limit(5).each do |hero|
      puts "Name: #{hero.name}, Experience: #{hero.experience}"
    end
    selection = @@prompt.select("Back to Main Menu?", %w(Main\ Menu), cycle: true)
    main_menu if selection == "Main Menu"
  end

  def display
    system("clear")
    puts @@header
  end

  def journey
    Journey.last
  end

  def hero
    journey.hero
  end

  def challenge
    journey.challenge
  end

  def game_over
    system("clear")
    puts "
    _______  _______  __   __  _______    _______  __   __  _______  ______   
    |       ||   _   ||  |_|  ||       |  |       ||  | |  ||       ||    _ |  
    |    ___||  |_|  ||       ||    ___|  |   _   ||  |_|  ||    ___||   | ||  
    |   | __ |       ||       ||   |___   |  | |  ||       ||   |___ |   |_||_ 
    |   ||  ||       ||       ||    ___|  |  |_|  ||       ||    ___||    __  |
    |   |_| ||   _   || ||_|| ||   |___   |       | |     | |   |___ |   |  | |
    |_______||__| |__||_|   |_||_______|  |_______|  |___|  |_______||___|  |_|
    " 
    selection = @@prompt.select("#{hero.name} has perished. Play again?", %w(New\ Game Main\ Menu), cycle: true)
    case selection
    when "New Game"
      new_game
    when "Main Menu"
      main_menu
    end
  end
end