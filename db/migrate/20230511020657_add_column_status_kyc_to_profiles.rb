class AddColumnStatusKycToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :status_kyc, :boolean, default: false
  end
end
