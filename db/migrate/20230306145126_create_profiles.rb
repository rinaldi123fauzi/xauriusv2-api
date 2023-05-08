class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :full_name
      t.integer :phone_number
      t.string :address
      t.integer :id_number
      t.string :npwp_number
      t.integer :deposit

      t.timestamps
    end
  end
end
