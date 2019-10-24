# This class acts as our frontend. Its job is to ineract with user input/output.
class GameApp 

  @@prompt = TTY::Prompt.new
  
  # Presents the player with application options.
  def main_menu
    display_title

    selection = @@prompt.select("Main Menu (type your selection in terminal):", %w(New\ Game Load\ Game Delete\ Game Leaderboard Exit\ Game),cycle: true)

    case selection
    when "New Game"
      new_game
    when "Load Game"
      load_game
    when "Delete Game"
      delete_game
    when "Leaderboard"
      leader_board
    when "Exit Game"
      exit
    end
  end
  
  # Allows the player to create a new Hero.
  def new_game
    display_title

    puts "What do they call you, hero?"
    name = gets.chomp
    if name.length != 0
      puts "Name is #{name}"
      @hero = Hero.create({name: name})
      go_on_a_journey
    else
      puts "Sorry, I couldn't hear you! (Name must be at least 1 character.)"
      sleep(2)
      new_game
    end
  end

  # Presenters the player with game options.
  def current_game
    display_title

    puts "Hero is #{@hero.name} with #{@hero.experience} experience and #{@hero.current_health} health."
    puts "\n\n"
    selection = @@prompt.select("What will you do now?", %w(Journey Shop Back\ to\ Main\ Menu), cycle: true)

    case selection
    when "Journey"
      go_on_a_journey
    when "Shop"
      shop
    when "Back to Main Menu"
      main_menu
    end
  end

  # Presents the player with options for a journey. If the player chooses to fight, it will defer to instance methods of @journey which handle fight logic.
  def go_on_a_journey
    # Initialize a journey for the hero.
    Monster.spooky_monster_generator
    Journey.start(@hero)
    @journey = Journey.last
    @monster = @journey.monster
    @hero = @journey.hero

    # Iterate in the journey unless hero dies, monster dies, or flee.
    while @hero.current_health > 0 && @monster.current_health > 0
      display_title
      display_journey_text
      choice = @@prompt.select("What will you do now?", %w(Fight Flee))
      case choice
      when "Fight"
        puts "\n\n"
        @journey.fight
      when "Flee"
        flee
      end
      system("clear")
    end

    # Reset the monster and return to current game menu, unless hero died.
    @monster.reset
    game_over if @hero.current_health == 0
    current_game
  end

  # A helper method for go_on_a_journey; handles display
  def display_journey_text
    puts "#{@monster.story}"
    puts "\n\n"
    puts "#{@hero.name} has #{@hero.current_health} health."
    puts "#{@monster.name} has #{@monster.current_health} health."
    puts "\n\n"
  end

  # A helper method for go_on_a_journey; handles flee logic
  def flee
    puts "You fled!"
    @monster.reset
    current_game
  end

  # Allows player to load previous games (any living Hero)
  def load_game
    if Hero.count > 0
      living_heroes = Hero.where("current_health > ?", 0).order('id DESC')
      display_living_heroes = living_heroes
        .map { |h| "#{h.name} with Experience: #{h.experience} and Current Health: #{h.current_health}"}
      load_choice = @@prompt.select("Select the hero who's journey you want to continue", display_living_heroes)
      @hero = living_heroes.find_by(name: load_choice.split[0])
      go_on_a_journey
    else
      puts "\n\n"
      puts "No hero journeys as of yet. Please start a New Game." 
    end
  end

  # Allows player to delete heroes and their associated journeys
  def delete_game
    if Hero.count > 0
      display_heroes = Hero.all.map {|h| "#{h.id}. #{h.name} with Experience: #{h.experience} and Health: #{h.current_health}."}
      delete_choice = @@prompt.select("Select the hero you want to delete.", display_heroes)
      delete_hero = Hero.find(delete_choice.split[0])
      system("clear")
      display_title
      delete_confirm = @@prompt.select("Are you sure you want to delete #{delete_hero.name}?", "Yes, delete #{delete_hero.name}", "No, go back to Main Menu.")
      case delete_confirm
      when "Yes, delete #{delete_hero.name}"
        Journey.where(:hero_id => delete_hero.id)
          .map {|journey| journey.id}
          .map {|id| Journey.destroy(id)}
        Hero.destroy(delete_hero.id)
        puts "\n\n"
        puts "#{delete_hero.name} deleted. Going back to Main Menu."
        sleep(3)
        main_menu
      when "No, go back to Main Menu."
        main_menu
      end
    else
      puts "\n\n"
      puts "No hero journeys as of yet. Please start a New Game." 
    end
  end

  # Allows player to spend experience points to improve their hero's health or power.
  def shop
    display_shop
    selection = @@prompt.select("What would you like to buy?", %w(EXP10-Potion(Restore\ Health) EXP5-Weapons(Increase\ Power) Back\ to\ Menu), cycle: true)
    case selection
    when "EXP10-Potion(Restore Health)"
      if @hero.experience >= 10
        @hero.update(current_health: @hero.max_health)
        @hero.update(experience: @hero.experience - 10)
        puts "Health restored! #{@hero.name} has #{@hero.max_health} health."
      else
        puts "Sorry, you don't have enough experience to buy this."
      end
      sleep(3)
      current_game
    when "EXP5-Weapons(Increase Power)"
      if @hero.experience >= 5
        @hero.update(power: @hero.power + 3)
        @hero.update(experience: @hero.experience - 5)
        puts "Power increased! #{@hero.name} has #{@hero.power} power."
      else
        puts "Sorry, you don't have enough experience to buy this."
      end
      sleep(3)
      current_game
    when "Back to Menu"
      current_game
    end
  end
  
  # Opens a leaderboard of heroes with the most journeys
  def leader_board
    display_leaderboard

    unranked_hero_journey_count = Journey.group(:hero_id).count(:monster_id)
    leaderboard = Hash[unranked_hero_journey_count.sort_by{|k,v|v}.reverse[0..4]]
    leaderboard.each do |hero_id, journey_count|
      puts "  Name: #{Hero.find(hero_id).name}, Journeys: #{journey_count}"
    end
    puts "\n\n"
    selection = @@prompt.select("Back to Main Menu?", %w(Main\ Menu), cycle: true)
    main_menu if selection == "Main Menu"
  end

  # Presents game over screen, incl. hero name and total journey count
  def game_over
    display_game_over
    puts "  #{@hero.name} has perished after #{Journey.where(:hero_id => @hero.id).count} journeys."
    sleep(3)
    main_menu
  end

  def display_title
    system("clear")
    puts "\n\n"
    puts "     
     __   __  _______  ______     _______  __   _______        ___  _______  __   __   ______    __    _  _______  __   __ 
    |██| |██||███████||███████|  |███████||██| |███████|      |███||███████||██| |██||███████|  |██|  |█||███████||██| |██|
    |██|_|██||███████||███| |█|  |███████||██| |███████|      |███||███████||██| |██||███| |█|  |███|_|█||███████||██|_|██|
    |███████||███|___ |███| |█|  |██| |██|     |█|_____       |███||██| |██||██|_|██||███| |█|  |███████||███|___ |███████|
    |███████||███████||█████████||██| |██|     |███████|   ___|███||██| |██||███████||█████████||███████||███████||███████|
    |███████||███|___ |███|  |██||███████|      _____|█|  |███████||███████||███████||███|  |██||█| |███||███|___   |███|  
    |██| |██||███████||███|  |██||███████|     |███████|  |███████||███████||███████||███|  |██||█|  |██||███████|  |███|  "
    puts "\n\n"
  end

  def display_shop
    system("clear")
    puts "\n\n"
    puts "
    ________  __   __  _______    _______  __   __  _______  _______ 
    |███████||██| |██||███████|  |███████||██| |██||███████||███████|
    |███████||██|_|██||███████|  |███████||██|_|██||███████||███████|
      |███|  |███████||███|___   |█|_____ |███████||██| |██||███| |█|
      |███|  |███████||███████|  |███████||███████||██| |██||███████|
      |███|  |███████||███|___    _____|█||███████||███████||███|    
      |███|  |██| |██||███████|  |███████||██| |██||███████||███|    
    "
    puts "\n\n"
    puts "Welcome to the Shop, #{@hero.name}. Here you can buy items with Experience. You have #{@hero.experience} points to spend."
  end

  def display_game_over
    system("clear")
    puts "\n\n"
    puts "
    ________  _______  __   __  _______    _______  __   __  _______  _______  
    |███████||███████||██|_|██||███████|  |███████||██| |██||███████||███████|  
    |███████||██| |██||███████||███████|  |███████||██|_|██||███████||███| |█|  
    |███| __ |███████||███████||███|___   |██| |██||███████||███|___ |███| |█| 
    |███| ██||███████||███████||███████|  |██| |██||███████||███████||████████|
    |███| |█||███████||█||█||█||███|___   |███████| |█████| |███|___ |███|  |█|
    |███████||██| |██||█|   |█||███████|  |███████|  |███|  |███████||███|  |█|
    " 
    puts "\n\n"
  end

  def display_leaderboard
    system("clear")
    puts "\n\n"
    puts "
    |███|    |███████||███████||█████|   ███████||██████|  |███████||███████||███████||███████|  |██████| 
    |███|    |███████||██| |██||███████||███████||███| █|  |█| |███||███████||██| |██||███| |█|  |███████|
    |███|    |███|___ |███████||█| |███||███|___ |███| █|  |███████||██| |██||███████||███| |█|  |█| |███|
    |███|___ |███████||███████||█| |███||███████||████████||██████| |██| |██||███████||█████████||█| |███|
    |███████||███|___ |███████||███████||███|___ |███|  |█||█| |███||███████||███████||███|  |█| |██████|
    |███████||███████||██| |██||█████|   ███████||███|  |█||███████||███████||██| |██||███|  |█| |█████| 
    "
    puts "\n\n"
    
  end
end