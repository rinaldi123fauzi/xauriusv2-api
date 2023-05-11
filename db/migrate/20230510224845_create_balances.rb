class CreateBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :balances do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance_value
      t.string :currency

      t.timestamps
    end
  end
end
