class CreateJourneys < ActiveRecord::Migration[5.2]
  create_table :journeys do |t|
    t.integer :hero_id
    t.integer :challenge_id
  end
end