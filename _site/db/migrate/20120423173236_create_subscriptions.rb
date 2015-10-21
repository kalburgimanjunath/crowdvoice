class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.integer :voice_id
      t.string :email_hash

      t.timestamps
    end
  end
end
