class CreateBankUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_users do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nama_akun
      t.string :nama_bank
      t.string :nomor_rekening
      t.boolean :status

      t.timestamps
    end
  end
end
