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

    selection = @@prompt.select("Main Menu (type your selection in terminal):", %w(New\ Game Load\ Game Leaderboard Exit\ Game),cycle: true)

    case selection
    when "New Game"
      new_game
    when "Load Game"
      load_game
    when "Leaderboard"
      leader_board
    when "Exit Game"
      exit_game
    end
  end
  
  def new_game
    display
    puts "What do they call you, hero?"
    name = gets.chomp
    puts "Name is #{name}"

    hero = Hero.new({name: name})
    if Challenge.all.length == 0
      Challenge.seed_challenges
    end
    #new_journey(hero)
    Journey.new_journey(hero)
    journey_turns
  end

  def current_game
    display
    puts "Hero is #{hero.name} with #{hero.experience} experience and #{hero.current_health} health."
    
    selection = @@prompt.select("What will you do now?", %w(Journey Shop Back\ to\ Main\ Menu), cycle: true)

    case selection
    when "Journey"
      new_journey
    when "Shop"
      shop
    when "Back to Main Menu"
      main_menu
    end
  end

  def new_journey(hero)
    Journey.new_journey(hero)
    journey_turns
  end

  def journey_turns
    #new_journey(hero)
    puts "#{challenge.story}"
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
    sleep(4)
    current_game
  end

  def load_game
    living_heroes = Hero.where("current_health > ?", 0).order('id DESC')
    display_living_heroes = living_heroes.map { |h| "#{h.name} Experience: #{h.experience}, Current Health:#{h.current_health}!"}
    hero_selection = @@prompt.select("Select the hero who's journey you want to continue", display_living_heroes)
    hero_name = hero_selection.split[0]
    selected_hero = living_heroes.find_by(name: hero_name)
    # Journey.load_journey(selected_hero)
    #Journey.new_journey(selected_hero)
    new_journey(selected_hero)
    current_game
  end

  def exit_game
    exit
  end

  def shop
    system("clear")
    puts "
    ________  __   __  _______    _______  __   __  _______  _______ 
    |       ||  | |  ||       |  |       ||  | |  ||       ||       |
    |_     _||  |_|  ||    ___|  |  _____||  |_|  ||   _   ||    _  |
      |   |  |       ||   |___   | |_____ |       ||  | |  ||   |_| |
      |   |  |       ||    ___|  |_____  ||       ||  |_|  ||    ___|
      |   |  |   _   ||   |___    _____| ||   _   ||       ||   |    
      |___|  |__| |__||_______|  |_______||__| |__||_______||___|    
    "
    
    puts "Welcome to the Shop, #{hero.name}. Here you can buy items with Experience. You have #{hero.experience} points to spend."
    selection = @@prompt.select("What would you like to buy?", %w(EXP10-Potion(Restore\ Health) Back\ to\ Menu), cycle: true)
    case selection
    when "EXP10-Potion(Restore Health)"
      if hero.experience > 10
        hero.update(current_health: hero.max_health) # Apply the item's effect
        hero.update(experience: hero.experience - 10) # Remove experience cost of item
      else
        puts "Sorry, you don't have enough experience to buy this."
        sleep(4)
      end
    when "Back to Menu"
      current_game
    end
    current_game
  end
  

  def leader_board
    # This should return the names of the five heroes with the longest runs (most experience), and their count.
    display
    # Hero.all.order('experience DESC').limit(5).each do |hero|
    #   puts "Name: #{hero.name}, Experience: #{hero.experience}"
    # end

    unsorted_hero_journey_count = Journey.group(:hero_id).count(:challenge_id)
    top_5_hero_journey_count = Hash[unsorted_hero_journey_count.sort_by{|k,v|v}.reverse[0..4]]
    top_5_hero_journey_count.each do |hero_id, journey_count|
      puts "Name: #{Hero.find(hero_id).name}, Journeys: #{journey_count}"
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
    selection = @@prompt.select("#{hero.name} has perished. Play again?", %w(New\ Game Load\ Game Main\ Menu), cycle: true)
    case selection
    when "New Game"
      new_game
    when "Load Game"
      load_game
    when "Main Menu"
      main_menu
    end
  end
end