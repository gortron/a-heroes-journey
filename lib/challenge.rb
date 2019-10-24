class Challenge < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys

  def self.seed_challenges
    # This method seeds the Challenges db with 5x challenges (name, story, experience, health, power)

    Challenge.create(name: "Big Bear", experience: 1, story: "You spot a colossal, scarred black bear ahead of you on the trail. It turns it's nose to the wind, looks at you, then begins to charge.", max_health: 100, current_health: 100, power: 20)
    Challenge.create(name: "Forest Run", experience: 2, story: "Collecting resources", max_health: 100, current_health: 100, power: 5)
    Challenge.create(name: "Serpent Attack", experience: 3, story: "A group of forest snakes have simultaneously attacked your hedgehog friend! You need to attack them to defend your friend", max_health: 100, current_health: 100, power:10)
    Challenge.create(name: "Wild Foxes", experience: 4, story: "A band of hungry foxes have found and attacked your supplies you need to defend them for your survival", max_health: 100, current_health: 100, power: 15)
    Challenge.create(name: "Angry Moose", experience: 5, story: "An angry moose is attacking your camping spot, don't let the moose trash your spot!", max_health: 100, current_health: 100, power: 20)
    Challenge.create(name: "United Beavers", experience: 6, story: "A bunch of hostile beavers are trying to take advantage of your recent battles; they have seen you battleing the moose and have now attacked simulatously", max_health: 100, current_health: 100, power: 20)
  end

  def self.spooky_monster_generator
    adj = %w(foggy foul dark moody quiet distant eery).sample
    place = %w(forest cave castle street country\ road inn).sample
    person_behavior = ["walk alone", "think you hear something", "look behind your back", "get a bad feeling in your stomach", "wonder when it was you last saw anyone", "are alone", "realize you haven't heard anything in hours","stop for breath"].sample
    spooky_question = ["Did you hear that?", "Where did your companions go?", "When did it get so quiet?", "What's there, in the shadows?", "Did something move behind you?", "That smell... sulfur?"].sample
    sense = %w(see hear smell notice).sample
    monster = %w(Werewolf Zombie Troll Demon Witch Ghoul Satyr Minotaur Ghost Skeleton).sample
    monster_adj = %w(Giant Cursed Angry Eldritch Demonic Spooky Ghostly).sample
    monster_behavior1 = %w(screeches howls screams pants roars threatens\ you).sample
    monster_behavior2 = %w(charge rush\ at\ you attack pace approach glare).sample
    sentiment = ["Shit.", "Here we go again.", "Get ready.", "You reach for your weapon.", "WTF?"].sample
    story = "Near a #{adj} #{place}, you #{person_behavior}. #{spooky_question} You #{sense} a #{monster_adj} #{monster}. It #{monster_behavior1}, and begins to #{monster_behavior2}. #{sentiment}"

    experience = rand(1..10)
    health = rand(25..150)
    power = rand(20..30)

    Challenge.create(name: "#{monster_adj} #{monster}", experience: experience, story: story, max_health: health, current_health: health, power: power)

  end

  def reset
    self.update(current_health: self.max_health)
  end
end