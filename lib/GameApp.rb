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

    @hero = Hero.create({name: name})
    go_on_a_journey
  end

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

  def go_on_a_journey
    Challenge.spooky_monster_generator
    Journey.start(@hero)
    @journey = Journey.last
    @challenge = @journey.challenge
    binding.pry
    #@hero = @journey.hero
    binding.pry
    while @hero.current_health > 0 && @challenge.current_health > 0
      
      display_title
      display_journey_text
      #binding.pry
      

      hero_choice = @@prompt.select("What will you do now?", %w(Fight Flee))
      case hero_choice
      when "Fight"
        puts "\n\n"
        @journey.fight
      when "Flee"
        flee
      end
      system("clear")
    end
    @challenge.reset
    game_over if @hero.current_health == 0
    current_game
  end

  def display_journey_text
    puts "#{@challenge.story}"
    puts "\n\n"
    binding.pry
    puts "#{@hero.name} has #{@hero.current_health} health."
    puts "#{@challenge.name} has #{@challenge.current_health} health."
    puts "\n\n"
  end

  def flee
    puts "You fled!"
    @challenge.reset
    current_game
  end

  def load_game
    living_heroes = Hero.where("current_health > ?", 0).order('id DESC')
    display_living_heroes = living_heroes.map { |h| 
      "#{h.name} with Experience: #{h.experience} and Current Health:#{h.current_health}"}
    hero_choices = @@prompt.select("Select the hero who's journey you want to continue", display_living_heroes)
    @hero = living_heroes.find_by(name: hero_choices.split[0])
    go_on_a_journey
  end

  def exit_game
    exit
  end

  def shop
    display_shop
  
    selection = @@prompt.select("What would you like to buy?", %w(EXP10-Potion(Restore\ Health) EXP5-Weapons(Increase\ Power) Back\ to\ Menu), cycle: true)
    case selection
    when "EXP10-Potion(Restore Health)"
      if @hero.experience >= 10
        @hero.update(current_health: @hero.max_health) # Apply the item's effect
        @hero.update(experience: @hero.experience - 10) # Remove experience cost of item
        puts "Health restored! #{@hero.name} has #{@hero.max_health} health."
      else
        puts "Sorry, you don't have enough experience to buy this."
      end
      sleep(3) # Give the user time to read the shop's message
      current_game
    when "EXP5-Weapons(Increase Power)"
      if @hero.experience >= 5
        @hero.update(power: @hero.power + 3) # Apply the item's effect
        @hero.update(experience: @hero.experience - 5) # Remove experience cost of item
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
  
  # This should return the names of the five heroes with the longest runs (most experience), and their count.
  def leader_board
    display_leaderboard

    unranked_hero_journey_count = Journey.group(:hero_id).count(:challenge_id)
    leaderboard = Hash[unranked_hero_journey_count.sort_by{|k,v|v}.reverse[0..4]]
    leaderboard.each do |hero_id, journey_count|
      puts "Name: #{Hero.find(hero_id).name}, Journeys: #{journey_count}"
    end
    puts "\n\n"
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

  # def journey
  #   Journey.last
  # end

  # def hero
  #   journey.hero
  # end

  # def challenge
  #   journey.challenge
  # end
end