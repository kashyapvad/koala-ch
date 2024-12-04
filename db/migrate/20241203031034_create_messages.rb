class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.string :user_content
      t.string :user_copy
      t.string :llm_model
      t.jsonb :llm_response
      t.string :llm_response_content
      t.belongs_to :inquiry, foreign_key: true
      t.timestamps
    end
  end
end
