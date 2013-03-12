class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.integer :mailbox_id
      t.string :local_part

      t.timestamps
    end
  end
end
