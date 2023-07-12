class AddColumnExpiredAtToOtps < ActiveRecord::Migration[7.0]
  def change
    add_column :otps, :expired_at, :timestamp
  end
end
