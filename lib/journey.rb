class Journey < ActiveRecord::Base
  belongs_to :heros
  belongs_to :challenges
  attr_accessor :hero_id, :challenge_id

  def self.new_journey(app)
    journey = self.new
    journey.hero_id = Hero.last.id
    journey.challenge_id = Challenge.all.sample.id
    journey.save
    puts "#{Challenge.find(journey.challenge_id).story}"
    app.journey_turn(journey)
  end

  def hero
    Hero.find(@hero_id)
  end

  def challenge
    Challenge.find(@challenge_id)
  end

  def save
    hero.save
    challenge.save
    puts "Game Saved"
  end

  def journey_turn_choice(app, turn_choice)
    case turn_choice
    when "Fight"
      fight(app)
    when "Flee"
      flee(app)
    end
    save
    app.journey_turn(self)
  end

  def fight(app)
    attack_resolver(hero, challenge)
    if challenge.current_health > 0
      attack_resolver(challenge, hero)
      app.game_over if hero.current_health <= 0
    else
      hero_win(app)
    end
  end

  def attack_resolver(attacker, defender)
    damage = (attacker.power * rand).to_i
    puts "#{attacker.name} attacks for #{damage} damage."
    defender.update(current_health: (defender.current_health - damage).clamp(0,100))
    puts "#{defender.name} now has #{defender.current_health} health."
  end
  
  def flee(app)
    puts "You flee from #{challenge.name}"
    app.current_game
  end

  def hero_win(app)
    puts "#{challenge.name} defeated! You gain #{challenge.experience} experience."
    hero.update(experience: hero.experience + challenge.experience)
    challenge.reset
    journey_end(app)
  end

  def journey_end(app)
    challenge.reset
    app.current_game
  end

end