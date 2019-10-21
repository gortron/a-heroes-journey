class Challenge < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys

  def seed_challenges
    # This method seeds the Challenges db with 5x challenges (name, story, experience, health, power)
  end
end