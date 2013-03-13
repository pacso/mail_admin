class CreateMailboxAliases < ActiveRecord::Migration
  def change
    create_table :mailbox_aliases do |t|
      t.integer :mailbox_id
      t.string :local_part

      t.timestamps
    end
  end
end
