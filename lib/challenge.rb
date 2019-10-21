class Challenge < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys

  def self.seed_challenges
    # This method seeds the Challenges db with 5x challenges (name, story, experience, health, power)
    i1 = Challenge.create(name: "Forest Run", experience: 2, story: "Collecting resources", health: 5, power: 5)
    i2 = Challenge.create(name: "Serpent Attack", experience: 3, story: "A group of forest snakes have simultaneously attacked your hedgehog friend! You need to attack them to defend your friend", health: 20, power:10)
    i3 = Challenge.create(name: "Wild Foxes", experience: 4, story: "A band of hungry foxes have found and attacked your supplies you need to defend them for your survival", health: 10, power: 15)
    i4 = Challenge.create(name: "Angry Moose", experience: 5, story: "An angry moose is attacking your camping spot, don't let the moose trash your spot!", health: 20, power: 20)
    i5 = Challenge.create(name: "United Beavers", experience: 6, story: "A bunch of hostile beavers are trying to take advantage of your recent battles; they have seen you battleing the moose and have now attacked simulatously", health: 25, power: 20)
  end
end