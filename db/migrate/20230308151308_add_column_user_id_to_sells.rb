class AddColumnUserIdToSells < ActiveRecord::Migration[7.0]
  def change
    add_reference :sells, :user, null: false, foreign_key: true
  end
end
