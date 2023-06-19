class CreateOadms < ActiveRecord::Migration[7.0]
  def change
    create_table :oadms do |t|
      t.string :oadm_email
      t.string :oadm_name
      t.string :oadm_password
      t.integer :oadm_passchange_token
      t.string :oadm_photo
      t.string :oadm_status
      t.string :google_secret
      t.string :reset_google_secret_token
      t.string :two_factor_is_active

      t.timestamps
    end
  end
end
