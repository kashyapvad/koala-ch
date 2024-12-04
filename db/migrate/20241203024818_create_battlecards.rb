class CreateBattlecards < ActiveRecord::Migration[7.2]
  def change
    create_table :battle_cards do |t|
      t.string :topic
      t.string :response
      t.timestamps
    end
  end
end
