class RenameChallengesToMonsters < ActiveRecord::Migration[5.2]
  def change
    rename_table :challenges, :monsters
  end
end