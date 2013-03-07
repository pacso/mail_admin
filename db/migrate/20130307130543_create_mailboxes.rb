class CreateMailboxes < ActiveRecord::Migration
  def change
    create_table :mailboxes do |t|
      t.integer :domain_id
      t.string :local_part
      t.string :password_digest
      t.boolean :enabled, default: true
      t.string :forwarding_address
      t.boolean :forwarding_enabled, default: false
      t.boolean :delivery_enabled, default: true
      t.boolean :delete_spam_enabled, default: true
      t.float :delete_spam_threshold, default: 7.5
      t.integer :delete_spam_threshold_int, default: 75
      t.boolean :move_spam_enabled, default: true
      t.float :move_spam_threshold, default: 3.5
      t.integer :move_spam_threshold_int, default: 35

      t.timestamps
    end
  end
end
