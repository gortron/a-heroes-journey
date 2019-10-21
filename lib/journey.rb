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
      challenge.update(current_health: challenge.current_health - hero.power)
      puts "#{challenge.name} now has #{challenge.current_health} health."
      if challenge.current_health <= 0
        puts "#{challenge.name} defeated!"
        hero.update(experience: hero.experience + challenge.experience)
        challenge.update(current_health: challenge.max_health)
        end_encounter(app)
      end
      puts "#{challenge.name} strikes back for #{challenge.power} damage."
      hero.update(current_health: hero.current_health - challenge.power)
      if hero.current_health <= 0
        app.game_over
      end
      puts "#{hero.name} now has #{hero.current_health} health."
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