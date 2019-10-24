class Journey < ActiveRecord::Base
  belongs_to :hero
  belongs_to :challenge

  def self.start(hero)
    challenge = Challenge.all.sample
    hero.challenges << challenge
  end

  def fight
    #hero_attack = attack_resolver(hero, challenge)
    hero_attack_display(attack_resolver(hero, challenge))
    if challenge.current_health > 0
      #monster_attack = attack_resolver(challenge, hero)
      monster_attack_display(attack_resolver(challenge, hero))
    else
      hero_win
    end
  end

  def attack_resolver(attacker, defender)
    #puts journey_display
    damage = (attacker.power * rand).to_i
    #puts "#{attacker.name} attacks for #{damage} damage."
    #binding.pry
    defender.update(current_health: (defender.current_health - damage).clamp(0,defender.max_health))
    #binding.pry
    #puts "#{defender.name} now has #{defender.current_health} health."
    #sleep(2)
    damage
  end

  def hero_win
    puts "#{challenge.name} defeated! You gain #{challenge.experience} experience."
    hero.update(experience: hero.experience + challenge.experience)
    reward
  end

  def reward
    system("clear")
    puts "
    _______    _______  _     _  _______  ______    ______   __   __   __  
    |    _ |  |       || | _ | ||   _   ||    _ |  |      | |  | |  | |  | 
    |   | ||  |    ___|| || || ||  |_|  ||   | ||  |  _    ||  | |  | |  | 
    |   |_||_ |   |___ |       ||       ||   |_||_ | | |   ||  | |  | |  | 
    |    __  ||    ___||       ||       ||    __  || |_|   ||__| |__| |__| 
    |   |  | ||   |___ |   _   ||   _   ||   |  | ||       | __   __   __  
    |___|  |_||_______||__| |__||__| |__||___|  |_||______| |__| |__| |__| 
    "
    rewards = ["some bandages", "a weapon", "a piece of armor"]
    reward = rewards.sample
    case reward
    when "some bandages"
      hero.update(current_health: hero.max_health)
      puts "Found #{reward}. Your health is restored."
    when "a weapon"
      weapon_power = rand(1..5)
      hero.update(power: hero.power + weapon_power)
      puts "Found #{reward}. Power increased by #{weapon_power}."
    when "a piece of armor"
      armor_power = rand(1..10)
      hero.update(max_health: hero.max_health + armor_power)
      puts "Found #{reward}. Max health increased by #{armor_power}."
    end
    sleep(3)
  end

  def hero_attack_display(damage)
  puts "#{hero.name}: Health: #{hero.current_health}, Power: #{hero.power}"
  puts " _______                  "
  puts "|_    _ |            /    *WHACK*"
  puts "|\\\\__// |           /   #{hero.name} does "
  puts "| |0 0| |          /      #{damage}  damage"
  puts "| \\_x_/ |        XX      to #{challenge.name}!"
  puts "| /   \\ |       //        "
  puts "| ||  |||       ^        "
  puts " ________                 "
  puts "\n"
  puts "#{challenge.name} now has #{challenge.current_health} health."
  sleep(4)
  puts "\n\n"
  end

  def monster_attack_display(damage)
    puts "#{challenge.name}: Health: #{challenge.current_health}, Power: #{challenge.power}"
    puts "\n"
    puts "*WHACK*"
    puts "#{challenge.name} does"
    puts "#{damage}  damage"
    puts "to #{hero.name}!"
    puts "      /   /  /      | ___  |       "
    puts "    //  //  //      | . .  |         "
    puts "    // //  //       |  ^   |               "
    puts "    / /   /         | vvv  |        "
    puts "\n"
    puts "#{hero.name} now has #{hero.current_health} health."
    sleep(4)
  end
end