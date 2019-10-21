class Journey < ActiveRecord::Base
  belongs_to :heros
  belongs_to :challenges

  def self.new_encounter
    journey = self.new
    @hero = Hero.last
    @challenge = Challenge.all.sample
    journey.hero_id = @hero.id
    journey.challenge_id = @challenge.id
    journey.save
    puts "#{@challenge.story}"
    GameApp.journey_turn(self)
  end

  def encounter(turn_choice)
    if @hero.health <= 0
      GameApp.game_over
    elsif @challenge.health <= 0
      end_encounter
    else
      puts "Encountering #{@challenge.name}"
      if turn_choice == "Fight"
        puts "You attack for #{@hero.power} damage."
        @challenge.health -= @hero.power
        puts "#{@challenge.name} strikes back for #{@challenge.power} damage."
        @hero.health -= @challenge.power
      else
        puts "You flee!"
        GameApp.current_game
      end
      GameApp.journey_turn(self)
    end
  end

  def end_encounter
  end
end