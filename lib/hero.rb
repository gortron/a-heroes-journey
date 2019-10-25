class Hero < ActiveRecord::Base
  has_many :journeys
  has_many :monsters, through: :journeys
  after_initialize :init

  # Sets default values for new heroes
  def init
    self.story ||= hero_story_generator
    self.experience ||= 1
    self.max_health ||= 100
    self.current_health ||= 100
    self.power ||= 20
    self.save
  end

  def hero_story_generator
    occupation = %w(student teacher builder programmer father mother doctor musician artist soldier policeman detective).sample
    sentiment = ["looked up to", "distrusted", "admired", "trusted", "cared about", "counseled", "ignored", "respected"].sample
    event = ["the war", "the divorce", "the haunting", "the invasion", "you were fired", "these damn monsters", "you were told about the prophecy"].sample
    activity = %w(wander survive explore journey fight play).sample
    motivation = ["that's the only thing you have left", "that's what matters now", "you need something to hold on to", "it keeps you sane", "you just love it", "your mom told you to", "because you made a promise, long ago"].sample
    
    hero_story = "You wake up. Nightmares, again. You were a #{occupation}, once. People #{sentiment} you. But that was before #{event}. Now, you #{activity} because #{motivation}. Time to get moving."
  end
  
end