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
    choice = gets.chomp

    case choice
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

  private
  
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
    enter_journey
  end

  def enter_journey
    puts "Enter Journey triggered"
    #Journey.new(hero.last)
  end

  def load_game
    puts "Load Game triggered"
    enter_journey

  end

  def save_game
    # I think the game auto-saves?
    puts "Save Game triggered"
  end

  def exit_game
    puts "Exit Game triggered"
    exit
  end

  def leader_board
    # This should return the names of the five heroes with the longest runs (most experience), and their count.
    puts "Leader Board triggered"
    #Heroes.order(:experience).limit(5)
  end

end