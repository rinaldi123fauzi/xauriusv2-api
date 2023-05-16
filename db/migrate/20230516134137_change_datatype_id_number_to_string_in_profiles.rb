class ChangeDatatypeIdNumberToStringInProfiles < ActiveRecord::Migration[7.0]
  def change
    change_column :profiles, :id_number, :string
  end
end
