class AddColumnStatusToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :status, :boolean
  end
end
