class CreateOadmrights < ActiveRecord::Migration[7.0]
  def change
    create_table :oadmrights do |t|
      t.bigint :oadm_id
      t.string :oadmright_controller
      t.string :oadmright_action
      t.string :oadmright_note
      t.boolean :oadmright_tf

      t.timestamps
    end
  end
end
