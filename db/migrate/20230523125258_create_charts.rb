class CreateCharts < ActiveRecord::Migration[7.0]
  def change
    create_table :charts do |t|
      t.decimal :copen
      t.decimal :clow
      t.decimal :chigh
      t.decimal :cclose
      t.datetime :cdate
      t.string :cdatestr

      t.timestamps
    end
  end
end
