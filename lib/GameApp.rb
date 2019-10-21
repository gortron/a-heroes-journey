class GameApp # This class acts as our frontend. Its only job is to ineract with user input/output.

  def main_menu
    # Main Menu presents the user with application options. User should be able to start new, load previous, save current, exit app, and see the leaderboard.

    puts "Welcome to A Hero's Journeys"

    puts "Main Menu (type your selection in terminal):\n
    New Game\n
    Load Game\n
    Save Game\n
    Exit Game\n
    Leaderboard"
    menu_choice = gets.chomp

    case menu_choice
    when "New Game"
      new_game
    when "Load Game"
      load_game
    when "Save Game"
      save_game
    when "Exit Game"
      exit_game
    when "Leaderboard"
      leader_board
    end

  end
  
  def new_game
    # This needs a refactor... this should be defined in class Hero
    puts "What do they call you, hero?"
    name = gets.chomp
    puts "Name is #{name}"
    hero = Hero.new
    hero.name = name
    hero.story = "A hardened veteran"
    hero.experience = 1
    hero.health = 100
    hero.power = 20
    hero.save
    current_game
  end

  def current_game
    puts "Current Game Triggered"
    puts "Hero is #{Hero.last.name} with #{Hero.last.experience} experience and #{Hero.last.health} health."
    puts "What will you do now?"
    puts "Journey\n
    Back to Main Menu"
    game_choice = gets.chomp
    case game_choice
    when "Journey"
      enter_journey
    when "Back to Main Menu"
      main_menu
    end
  end

  def enter_journey
    puts "Enter Journey triggered"
    Journey.new_encounter(self)
  end

  def journey_turn(journey)
    puts "What will you do now?"
    puts "Fight\n
    Flee"
    turn_choice = gets.chomp
    journey.encounter(self, turn_choice)
    # case turn_choice
    # when "Fight"
    #   puts "You fight!"
    #   journey.encounter
    # when "Flee"
    #   puts "You flee!"
    #   current_game
    # end
  end

  def load_game
    puts "Load Game triggered"
    current_game
  end

  def save_game
    # I think the game auto-saves?
    puts "Save Game triggered"
    main_menu
  end

  def exit_game
    puts "Exit Game triggered"
    exit
  end

  def self.game_over
    puts "Game Over! #{Hero.all.last.name} has perished."
  end

  def leader_board
    # This should return the names of the five heroes with the longest runs (most experience), and their count.
    puts "Leader Board triggered"
    Hero.all.order('experience DESC').limit(5).each do |hero|
      puts "Name: #{hero.name}, Experience: #{hero.experience}"
    end
    main_menu
  end

end