class CreateMailGroupMemberships < ActiveRecord::Migration
  def change
    create_table :mail_group_memberships do |t|
      t.integer :mail_group_id
      t.integer :mailbox_id

      t.timestamps
    end
  end
end
