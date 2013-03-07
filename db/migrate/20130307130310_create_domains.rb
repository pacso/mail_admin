class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.boolean :enabled, default: true
      t.boolean :can_relay, default: false

      t.timestamps
    end
  end
end
