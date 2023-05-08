class AddColumnUserIdToWithdraws < ActiveRecord::Migration[7.0]
  def change
    add_reference :withdraws, :user, null: false, foreign_key: true
  end
end
