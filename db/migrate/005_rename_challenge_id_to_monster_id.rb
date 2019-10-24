class RenameChallengeIdToMonsterId < ActiveRecord::Migration[5.2]
  def change
    rename_column :journeys, :challenge_id, :monster_id
  end
end