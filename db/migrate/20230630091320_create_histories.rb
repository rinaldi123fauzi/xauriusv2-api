class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.bigint :user_id
      t.string :table
      t.bigint :table_id

      t.timestamps
    end
  end
end
