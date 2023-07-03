class CreateOtps < ActiveRecord::Migration[7.0]
  def change
    create_table :otps do |t|
      t.bigint :user_id
      t.bigint :otp

      t.timestamps
    end
  end
end
