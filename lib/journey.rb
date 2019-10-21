class Journey < ActiveRecord::Base
  belongs_to :heros
  belongs_to :challenges
  attr_accessor :hero_id, :challenge_id

  def self.new_encounter(app)
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

  def encounter(app, turn_choice)
    puts "Encountering #{challenge.name}"
    if turn_choice == "Fight"
      puts "You attack for #{hero.power} damage."
      challenge.update(health: challenge.health - hero.power)
      puts "#{challenge.name} now has #{challenge.health} health."
      if challenge.health <= 0
        puts "#{challenge.name} defeated!"
        hero.update(experience: hero.experience + challenge.experience)
        end_encounter(app)
      end
      puts "#{challenge.name} strikes back for #{challenge.power} damage."
      hero.update(health: hero.health - challenge.power)
      if hero.health <= 0
        app.game_over
      end
      puts "#{hero.name} now has #{hero.health} health."
    else
      puts "You flee!"
      app.current_game
    end
    app.journey_turn(self)
  end

  def end_encounter(app)
    app.current_game
  end
end