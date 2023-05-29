class CreateAntamprices < ActiveRecord::Migration[6.0]
  def change
    create_table :antamprices do |t|
      t.text :antamprice_scaptext

      t.timestamps
    end
  end
end
