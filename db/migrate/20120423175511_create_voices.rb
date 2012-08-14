class CreateVoices < ActiveRecord::Migration
  def change
    create_table :voices do |t|
      t.string :title
      t.text :description
      t.string :theme
      t.integer :user_id
      t.string :slug
      t.string :logo
      t.string :logo_link
      t.string :sponsor_slogan
      t.string :sponsor
      t.string :background
      t.string :background_copyright
      t.string :latitude
      t.string :longitude
      t.string :location
      t.string :map_url
      t.string :twitter_search
      t.boolean :featured, :default => false
      t.boolean :archived, :default => false
      t.string :rss_feed
      t.datetime :last_rss
      t.datetime :last_tweet
      t.boolean :approved, :default => false
      t.integer :background_thumb_width
      t.integer :background_thumb_height
      t.string :background_version, :default => 'square'
      t.string :square_background
      t.integer :square_background_width
      t.string :wide_background
      t.integer :wide_background_width
      t.integer :wide_background_height
      t.integer :square_background_height
      t.integer :home_position

      t.timestamps
    end
  end
end
