class Monster < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys

  # Sets the monster's health to full, called when a monster is defeated
  def reset
    self.update(current_health: self.max_health)
  end
end