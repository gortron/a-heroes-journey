class Journey < ActiveRecord::Base
  include Display
  include Generators
  belongs_to :hero
  belongs_to :monster

  # Starts a journey and joins a Monster to a Hero
  def self.start(hero)
    monster = Monster.all.sample
    hero.monsters << monster
  end

  # Logic that handles when a player chooses Fight
  def fight
    display_hero_attack(attack_resolver(hero, monster))
    if monster.current_health > 0
      display_monster_attack(attack_resolver(monster, hero))
    else
      hero_win
    end
  end

  # Helper method for fight
  def attack_resolver(attacker, defender)
    damage = (attacker.power * rand).to_i
    defender.update(current_health: (defender.current_health - damage).clamp(0,defender.max_health))
    damage
  end

  # Handles logic for winning a journey
  def hero_win
    puts "#{monster.name} defeated! You gain #{monster.experience} experience."
    hero.update(experience: hero.experience + monster.experience)
    reward
  end

  # Handles logic for reward after Hero wins a journey
  def reward
    display_reward
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

end