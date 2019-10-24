class Journey < ActiveRecord::Base
  belongs_to :hero
  belongs_to :challenge

  def self.start(hero)
    challenge = Challenge.all.sample
    hero.challenges << challenge
  end

  def fight
    hero_attack_display(attack_resolver(hero, challenge))
    if challenge.current_health > 0
      monster_attack_display(attack_resolver(challenge, hero))
    else
      hero_win
    end
  end

  def attack_resolver(attacker, defender)
    damage = (attacker.power * rand).to_i
    defender.update(current_health: (defender.current_health - damage).clamp(0,defender.max_health))
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
    ________   ________  _     _  _______  _______    ______   __   __   __  
    |███████|  |███████||█| _ |█||███████||███████|  |██████| |██| |██| |██| 
    |███| |█|  |███████||█||█||█||██| |██||███| |█|  |███████||██| |██| |██| 
    |███| |█|  |███|___ |███████||███████||███| |█|  |█| |███||██| |██| |██| 
    |████████| |███████||███████||███████||████████| |█| |███||██| |██| |██| 
    |███|  |█| |███|___ |███████||███████||███|  |█| |██████|  __   __   __  
    |███|  |█| |███████||██| |██||██| |██||███|  |█| |█████|  |██| |██| |██| 
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
  puts "\n"
  puts attack_story_generator(hero, challenge)
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
  sleep(6)
  puts "\n\n"
  end

  def monster_attack_display(damage)
    puts "#{challenge.name}: Health: #{challenge.current_health}, Power: #{challenge.power}"
    puts "\n"
    puts attack_story_generator(challenge, hero)
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
    sleep(6)
  end

  def attack_story_generator(attacker, defender)
    attacker = attacker.name
    defender = defender.name
    verb1 = %w(paces moves stalks prowls runs).sample
    thought = ["waiting for an opportunity", "looking for an opening", "wiping blood off their face", "anger in their eyes"].sample
    sentiment = ["Is it too late to flee?", "They are looking for a way out.", "Instinct kicks in, and time slows as you focus.", "Holy hell.", "You think their head would like nice on your wall.", "Shit."].sample
    verb2 = %w(lunges jumps attacks yells stamps\ their\ feet taunts).sample
    error = ["misses", "doesn't see it coming", "is too slow", "it happens too fast", "has horrible aim", "trips", "stumbles", "looks confused"].sample
    attack = ["scrapes", "claws", "swings their fist", "throws a rock", "kicks out", "swings a weapon", "punches", "headbutts", "stabs"].sample

    attack_story = "#{attacker} #{verb1} around #{defender}, #{thought}. #{sentiment} #{defender} #{verb2}, but #{error}. #{attacker} #{attack}!"
  end
end