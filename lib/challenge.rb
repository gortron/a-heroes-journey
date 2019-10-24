class Challenge < ActiveRecord::Base
  has_many :journeys
  has_many :heros, through: :journeys

  # Generates a random monster, called when a hero starts a journey
  def self.spooky_monster_generator
    adj = %w(foggy foul dark moody quiet distant eery).sample
    place = %w(forest cave castle street country\ road inn).sample
    person_behavior = ["walk alone", "think you hear something", "look behind your back", "get a bad feeling in your stomach", "wonder when it was you last saw anyone", "are alone", "realize you haven't heard anything in hours","stop for breath"].sample
    spooky_question = ["Did you hear that?", "Where did your companions go?", "When did it get so quiet?", "What's there, in the shadows?", "Did something move behind you?", "That smell... sulfur?"].sample
    sense = %w(see hear smell notice).sample
    monster_type = %w(Werewolf Zombie Troll Demon Witch Ghoul Satyr Minotaur Ghost Skeleton).sample
    monster_adj = %w(Giant Cursed Angry Eldritch Demonic Spooky Ghostly).sample
    monster_behavior1 = %w(screeches howls screams pants roars threatens\ you).sample
    monster_behavior2 = %w(charge rush\ at\ you attack pace approach glare).sample
    sentiment = ["Shit.", "Here we go again.", "Get ready.", "You reach for your weapon.", "WTF?"].sample
    story = "Near a #{adj} #{place}, you #{person_behavior}. #{spooky_question} You #{sense} a #{monster_adj} #{monster_type}. It #{monster_behavior1}, and begins to #{monster_behavior2}. #{sentiment}"

    experience = rand(1..10)
    health = rand(25..150)
    power = rand(20..30)

    Challenge.create(name: "#{monster_adj} #{monster_type}", experience: experience, story: story, max_health: health, current_health: health, power: power)

  end

  # Sets the monster's health to full, called when a monster is defeated
  def reset
    self.update(current_health: self.max_health)
  end
end