module Generators

  # Generates a random hero story, when a hero is created in GameApp/new_game
  def hero_story_generator
    occupation = %w(student teacher builder programmer father mother doctor musician artist soldier policeman detective).sample
    sentiment = ["looked up to", "distrusted", "admired", "trusted", "cared about", "counseled", "ignored", "respected"].sample
    event = ["the war", "the divorce", "the haunting", "the invasion", "you were fired", "these damn monsters", "you were told about the prophecy"].sample
    activity = %w(wander survive explore journey fight play).sample
    motivation = ["that's the only thing you have left", "that's what matters now", "you need something to hold on to", "it keeps you sane", "you just love it", "your mom told you to", "because you made a promise, long ago"].sample
    
    hero_story = "You wake up. Nightmares, again. You were a #{occupation}, once. People #{sentiment} you. But that was before #{event}. Now, you #{activity} because #{motivation}. Time to get moving."
  end

  # Generates a random monster, called in GameApp/go_on_a_journey. 30M possible combinations!
  def spooky_monster_generator
    adj = %w(foggy foul dark moody quiet distant eery).sample
    place = %w(forest cave castle street country\ road inn).sample
    person_behavior = ["walk alone", "think you hear something", "look behind your back", "get a bad feeling in your stomach", "wonder when it was you last saw anyone", "are alone", "realize you haven't heard anything in hours","stop for breath"].sample
    spooky_question = ["Did you hear that?", "Where did your companions go?", "When did it get so quiet?", "What's there, in the shadows?", "Did something move behind you?", "That smell... sulfur?"].sample
    sense = %w(see hear smell notice).sample
    monster_type = %w(Werewolf Zombie Troll Demon Witch Ghoul Satyr Minotaur Ghost Skeleton).sample
    monster_adj = %w(Giant Cursed Angry Eldritch Demonic Spooky Ghostly).sample
    monster_behavior1 = %w(screeches howls screams pants roars threatens\ you).sample
    monster_behavior2 = %w(charge rush\ at\ you attack pace approach glare).sample
    sentiment = ["Shit.", "This time, it's personal.", "Get ready.", "You reach for your weapon.", "WTF?"].sample
    
    story = "Near a #{adj} #{place}, you #{person_behavior}. #{spooky_question} You #{sense} a #{monster_adj} #{monster_type}. It #{monster_behavior1}, and begins to #{monster_behavior2}. #{sentiment}"

    experience = rand(1..10)
    health = rand(25..150)
    power = rand(20..30)

    Monster.create(name: "#{monster_adj} #{monster_type}", experience: experience, story: story, max_health: health, current_health: health, power: power)
  end

  def attack_story_generator(attacker, defender)
    attacker = attacker.name
    defender = defender.name
    verb1 = %w(paces moves stalks prowls runs).sample
    thought = ["waiting for an opportunity", "looking for an opening", "wiping blood off their face", "anger in their eyes"].sample
    sentiment = ["Is it too late to flee?", "They are looking for a way out.", "Instinct kicks in, and time slows as you focus.", "Holy hell.", "You think their head would like nice on your wall.", "Shit."].sample
    verb2 = %w(lunges jumps attacks yells stamps\ their\ feet taunts).sample
    error = ["misses", "doesn't see it coming", "is too slow", "it happens too fast", "has horrible aim", "trips", "stumbles", "looks confused"].sample
    attack = ["scrapes", "claws", "swings their fist", "throws a rock", "kicks out", "swings a weapon", "punches", "headbutts", "stabs"].sample

    attack_story = "#{attacker} #{verb1} around #{defender}, #{thought}. #{sentiment} #{defender} #{verb2}, but #{error}. #{attacker} #{attack}!"
  end
end