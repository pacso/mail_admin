class CreateMailGroups < ActiveRecord::Migration
  def change
    create_table :mail_groups do |t|
      t.integer :domain_id
      t.string :local_part
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
