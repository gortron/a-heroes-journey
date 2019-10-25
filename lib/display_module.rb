module Display

  # Display helper for GameApp
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

  # Display helper for GameApp/shop
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
    puts "\n\n"
  end

  # Display helper for GameApp/game_over
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

  # Display helper for GameApp/leaderboard
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

  # Display helper for Journey/fight
  def display_reward
    system("clear")
    puts "
    ________   ________  _     _  _______  _______    ______   __   __   __  
    |███████|  |███████||█| _ |█||███████||███████|  |██████| |██| |██| |██| 
    |███| |█|  |███████||█||█||█||██| |██||███| |█|  |███████||██| |██| |██| 
    |███| |█|  |███|___ |███████||███████||███| |█|  |█| |███||██| |██| |██| 
    |████████| |███████||███████||███████||████████| |█| |███||██| |██| |██| 
    |███|  |█| |███|___ |███████||███████||███|  |█| |██████|  __   __   __  
    |███|  |█| |███████||██| |██||██| |██||███|  |█| |█████|  |██| |██| |██| 
    "
    puts "\n\n"
  end

  # Display helper for GameApp/delete_game & load_game
  def display_no_heroes
    puts "\n\n"
    puts "No hero journeys as of yet. Please start a New Game." 
    sleep(3)
  end

  # A helper method for GameApp/go_on_a_journey; handles display
  def display_journey_text
    puts "#{@monster.story}"
    puts "\n\n"
    puts "#{@hero.name} has #{@hero.current_health} health."
    puts "#{@monster.name} has #{@monster.current_health} health."
    puts "\n\n"
  end

  # A helper method for journey/fight; handles hero display
  def display_hero_attack(damage)
    puts "#{hero.name}: Health: #{hero.current_health}, Power: #{hero.power}"
    puts "\n"
    puts attack_story_generator(hero, monster)
    sleep(2)
    puts " _______                  "
    puts "|_    _ |            /    *WHACK*"
    puts "|\\\\__// |           /   #{hero.name} does "
    puts "| |0 0| |          /      #{damage}  damage"
    puts "| \\_x_/ |        XX      to #{monster.name}!"
    puts "| /   \\ |       //        "
    puts "| ||  |||       ^        "
    puts " ________                 "
    puts "\n"
    sleep(2)
    puts "#{monster.name} now has #{monster.current_health} health."
    sleep(2)
    puts "\n\n"
  end

  # A helper method for journey/fight; handles monster display
  def display_monster_attack(damage)
    puts "\n"
    puts attack_story_generator(monster, hero)
    sleep(2)
    puts "\n"
    puts "*WHACK*"
    puts "#{monster.name} does"
    puts "#{damage}  damage"
    puts "to #{hero.name}!"
    puts "      /   /  /      | ___  |       "
    puts "    //  //  //      | . .  |         "
    puts "    // //  //       |  ^   |               "
    puts "    / /   /         | vvv  |        "
    puts "\n"
    sleep(2)
    puts "#{hero.name} now has #{hero.current_health} health."
    sleep(2)
  end

end