class Challenge < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys
end