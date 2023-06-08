class ChangeDatatypeStatusKycToProfiles < ActiveRecord::Migration[7.0]
  def change
    change_column :profiles, :status_kyc, :string
  end
end
