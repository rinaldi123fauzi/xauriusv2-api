class AddColumnCountryToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :country, :string
  end
end
