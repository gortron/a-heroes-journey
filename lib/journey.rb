class Journey < ActiveRecord::Base
  belongs_to :hero
  belongs_to :challenge

  def self.new_journey
    hero = Hero.last
    challenge = Challenge.all.sample
    hero.challenges << challenge
    puts "#{challenge.story}"
  end

  def fight
    attack_resolver(hero, challenge)
    if challenge.current_health > 0
      attack_resolver(challenge, hero)
    else
      hero_win
    end
  end

  def attack_resolver(attacker, defender)
    damage = (attacker.power * rand).to_i
    puts "#{attacker.name} attacks for #{damage} damage."
    defender.update(current_health: (defender.current_health - damage).clamp(0,100))
    puts "#{defender.name} now has #{defender.current_health} health."
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
      weapon_power = (hero.power * 2/10 * rand).to_i
      hero.update(power: hero.power + weapon_power)
      puts "Found #{reward}. Power increased by #{weapon_power}."
    when "a piece of armor"
      armor_power = (hero.max_health * 2/10 * rand).to_i
      hero.update(max_health: hero.max_health + armor_power)
      puts "Found #{reward}. Max health increased by #{armor_power}."
    end
  end

end