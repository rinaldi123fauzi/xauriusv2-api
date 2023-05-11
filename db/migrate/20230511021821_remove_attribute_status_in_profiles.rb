class RemoveAttributeStatusInProfiles < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :status
  end
end
