class Journey < ActiveRecord::Base
  belongs_to :hero
  belongs_to :challenge

  def self.new_journey
    hero = Hero.last
    challenge = Challenge.all.sample
    hero.challenges << challenge
    puts "#{challenge.story}"
  end

  def save
    hero.save
    challenge.save
    puts "Game Saved"
  end

  # def journey_turn_choice(app, turn_choice)
  #   case turn_choice
  #   when "Fight"
  #     fight(app)
  #   when "Flee"
  #     flee(app)
  #   end
  #   save
  #   app.journey_turn
  # end

  # def fight(app)
  def fight
    attack_resolver(hero, challenge)
    if challenge.current_health > 0
      attack_resolver(challenge, hero)
      # if hero.current_health <= 0
      #   #challenge.reset
      # #   #app.game_over 
      # end
    else
      # hero_win(app)
      hero_win
    end
    #app.journey_turn
  end

  def attack_resolver(attacker, defender)
    damage = (attacker.power * rand).to_i
    puts "#{attacker.name} attacks for #{damage} damage."
    defender.update(current_health: (defender.current_health - damage).clamp(0,100))
    puts "#{defender.name} now has #{defender.current_health} health."
  end
  
  # def flee(app)
  #   puts "You flee from #{challenge.name}"
  #   app.current_game
  # end

  def hero_win
  # def hero_win(app)
    puts "#{challenge.name} defeated! You gain #{challenge.experience} experience."
    hero.update(experience: hero.experience + challenge.experience)
    reward
    #challenge.reset
    # journey_end(app)
  end

  def reward
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

  # def journey_end(app)
  #   challenge.reset
  #   app.current_game
  # end

end