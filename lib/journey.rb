class Journey < ActiveRecord::Base
  belongs_to :heros
  belongs_to :challenges
end