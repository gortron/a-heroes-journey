class CreateHeroes < ActiveRecord::Migration[5.2]
  create_table :heroes do |t|
    t.string :name
    t.integer :experience
    t.string :story
    t.integer :health
    t.integer :power
  end
end