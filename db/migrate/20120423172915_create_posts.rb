class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :voice_id
      t.integer :user_id
      t.string :title
      t.string :description
      t.integer :positive_votes_count, :default => 0
      t.integer :negative_votes_count, :default => 0
      t.integer :overall_score,        :default => 0
      t.string :source_url
      t.string :source_type
      t.string :source_service
      t.string :image
      t.boolean :approved, :default => false
      t.string :copyright
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end
  end
end
