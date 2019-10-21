class Hero < ActiveRecord::Base
  has_many :journeys
  has_many :challenges, through: :journeys

end