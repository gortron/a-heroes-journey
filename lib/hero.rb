class Hero < ActiveRecord::Base
  include Generators
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

  
  
end