class ProfileAddImage < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :file_npwp, :string 
    add_column :profiles, :file_ktp, :string 
    add_column :profiles, :image, :string 
  end
end