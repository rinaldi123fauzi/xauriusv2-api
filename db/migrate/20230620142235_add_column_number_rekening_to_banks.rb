class AddColumnNumberRekeningToBanks < ActiveRecord::Migration[7.0]
  def change
    add_column :banks, :number_rekening, :string
  end
end
