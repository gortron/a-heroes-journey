# This class acts as our frontend. Its only job is to ineract with user input/output.
class GameApp 

  @@prompt = TTY::Prompt.new
  
  # Main Menu presents the user with application options. User should be able to start new, load previous, save current, exit app, and see the leaderboard.
  def main_menu
    display_title

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
    display_title

    puts "What do they call you, hero?"
    name = gets.chomp
    puts "Name is #{name}"

    hero = Hero.new({name: name})
    go_on_a_journey(hero)
  end

  def current_game
    display_title

    puts "Hero is #{hero.name} with #{hero.experience} experience and #{hero.current_health} health."
    selection = @@prompt.select("What will you do now?", %w(Journey Shop Back\ to\ Main\ Menu), cycle: true)

    case selection
    when "Journey"
      go_on_a_journey(hero)
    when "Shop"
      shop
    when "Back to Main Menu"
      main_menu
    end
  end

  def go_on_a_journey(input_hero)
    Challenge.spooky_monster_generator
    Journey.start(input_hero)
    while hero.current_health > 0 && challenge.current_health > 0
      
      display_title
      puts "#{challenge.story}"
      puts "#{hero.name} has #{hero.current_health} health."
      puts "#{challenge.name} has #{challenge.current_health} health."

      hero_choice = @@prompt.select("What will you do now?", %w(Fight Flee))
      case hero_choice
      when "Fight"
        journey.fight

      when "Flee"
        flee
      end
      system("clear")
    end
    challenge.reset
    game_over if hero.current_health == 0
    sleep(3) # Gives time for the user to see their reward
    current_game
  end

  def flee
    puts "You fled!"
    challenge.reset
    current_game
  end

  def load_game
    living_heroes = Hero.where("current_health > ?", 0).order('id DESC')
    display_living_heroes = living_heroes.map { |h| 
      "#{h.name} with Experience: #{h.experience} and Current Health:#{h.current_health}"}
    hero_choices = @@prompt.select("Select the hero who's journey you want to continue", display_living_heroes)
    hero_chosen = living_heroes.find_by(name: hero_choices.split[0])
    go_on_a_journey(hero_chosen)
  end

  def exit_game
    exit
  end

  def shop
    display_shop
  
    selection = @@prompt.select("What would you like to buy?", %w(EXP10-Potion(Restore\ Health) Back\ to\ Menu), cycle: true)
    case selection
    when "EXP10-Potion(Restore Health)"
      if hero.experience >= 10
        hero.update(current_health: hero.max_health) # Apply the item's effect
        hero.update(experience: hero.experience - 10) # Remove experience cost of item
        puts "Health restored! #{hero.name} has #{hero.max_health} health."
      else
        puts "Sorry, you don't have enough experience to buy this."
      end
      sleep(3) # Give the user time to read the shop's message
      current_game
    when "Back to Menu"
      current_game
    end
  end
  
  # This should return the names of the five heroes with the longest runs (most experience), and their count.
  def leader_board
    display_title

    unranked_hero_journey_count = Journey.group(:hero_id).count(:challenge_id)
    leaderboard = Hash[unranked_hero_journey_count.sort_by{|k,v|v}.reverse[0..4]]
    leaderboard.each do |hero_id, journey_count|
      puts "Name: #{Hero.find(hero_id).name}, Journeys: #{journey_count}"
    end

    selection = @@prompt.select("Back to Main Menu?", %w(Main\ Menu), cycle: true)
    main_menu if selection == "Main Menu"
  end

  def game_over
    display_game_over
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

  def display_title
    system("clear")
    puts "     __   __  _______  ______    _______  __   _______        ___  _______  __   __  ______    __    _  _______  __   __ 
    |  | |  ||       ||    _ |  |       ||  | |       |      |   ||       ||  | |  ||    _ |  |  |  | ||       ||  | |  |
    |  |_|  ||    ___||   | ||  |   _   ||__| |  _____|      |   ||   _   ||  | |  ||   | ||  |   |_| ||    ___||  |_|  |
    |       ||   |___ |   |_||_ |  | |  |     | |_____       |   ||  | |  ||  |_|  ||   |_||_ |       ||   |___ |       |
    |       ||    ___||    __  ||  |_|  |     |_____  |   ___|   ||  |_|  ||       ||    __  ||  _    ||    ___||_     _|
    |   _   ||   |___ |   |  | ||       |      _____| |  |       ||       ||       ||   |  | || | |   ||   |___   |   |  
    |__| |__||_______||___|  |_||_______|     |_______|  |_______||_______||_______||___|  |_||_|  |__||_______|  |___|  "
  end

  def display_shop
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
  end

  def display_game_over
    system("clear")
    puts "
    ________  _______  __   __  _______    _______  __   __  _______  ______   
    |       ||   _   ||  |_|  ||       |  |       ||  | |  ||       ||    _  |  
    |    ___||  |_|  ||       ||    ___|  |   _   ||  |_|  ||    ___||   | | |  
    |   | __ |       ||       ||   |___   |  | |  ||       ||   |___ |   |_| |_ 
    |   ||  ||       ||       ||    ___|  |  |_|  ||       ||    ___||    __  |
    |   |_| ||   _   || ||_|| ||   |___   |       | |     | |   |___ |   |  | |
    |_______||__| |__||_|   |_||_______|  |_______|  |___|  |_______||___|  |_|
    " 
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