class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.string :ip_address
      t.integer :rating
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
