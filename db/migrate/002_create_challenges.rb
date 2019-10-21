class CreateChallenges < ActiveRecord::Migration[5.2]
  create_table :challenges do |t|
    t.string :name
    t.integer :experience
    t.string :story
    t.integer :max_health
    t.integer :current_health
    t.integer :power
  end
end