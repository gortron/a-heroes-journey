class Hero < ActiveRecord::Base
  has_many :journeys
  has_many :challenges, through: :journeys

  # Why does the intialize method below not work?
  # def initialize(proc)
  #   @name = proc[:name]
  #   @story = proc[:story]
  #   @experience = proc[:experience]
  #   @health = proc[:health]
  #   @power = proc[:power]
  # end
end