class RemoveAttributeDepositToProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :deposit
  end
end
