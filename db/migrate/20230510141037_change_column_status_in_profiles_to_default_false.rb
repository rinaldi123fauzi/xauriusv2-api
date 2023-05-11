class ChangeColumnStatusInProfilesToDefaultFalse < ActiveRecord::Migration[7.0]
  def change
    change_column :profiles, :status, :boolean, default: false
  end
end
