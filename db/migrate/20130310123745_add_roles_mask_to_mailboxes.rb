class AddRolesMaskToMailboxes < ActiveRecord::Migration
  def change
    add_column :mailboxes, :roles_mask, :integer
  end
end
