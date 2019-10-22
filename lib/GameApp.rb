class GameApp # This class acts as our frontend. Its only job is to ineract with user input/output.

  @@prompt = TTY::Prompt.new
  
  def main_menu
    # Main Menu presents the user with application options. User should be able to start new, load previous, save current, exit app, and see the leaderboard.

    puts "Welcome to A Hero's Journeys"

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
    
    selection = @@prompt.select("What will you do now?", %w(Journey Back\ to\ Main\ Menu), cycle: true)

    case selection
    when "Journey"
      enter_journey
    when "Back to Main Menu"
      main_menu
    end
  end

  def enter_journey
    puts "Enter Journey triggered"
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
        current_game
      end
    end
    challenge.reset
    game_over if hero.current_health == 0
    current_game
  end

  def load_game
    puts "Load Game triggered"
    if hero.current_health > 0
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
    puts "Game Over! #{hero.name} has perished."
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

  def journey
    Journey.last
  end

  def hero
    journey.hero
  end

  def challenge
    journey.challenge
  end

end