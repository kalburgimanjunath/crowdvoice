require File.expand_path('config/environment.rb')
require 'open-uri'

class Post < Thor
  desc "update_image_dimensions", "fetchs all images and update the post tieh the dimensions"
  def update_image_dimensions
    'Post'.constantize.all.each do |post|
      if post.image_width.nil?
        puts "#{post.id} >>> #{post.image.url}"
        begin
          open(post.image.url) do |file|
            image = MiniMagick::Image.read(file.read) rescue nil
            post.update_attributes(:image_width => image[:width], :image_height => image[:height])
          end
        rescue => e
        end
      end
    end
  end

  desc "clear_cache_files", "Remove all the files cached with more than one day old"
  def clear_cache_files
    CarrierWave.clean_cached_files!
  end

  desc "safe_posts_content", "Removed unsafe content on title and description"
  def safe_posts_content
    Voice.all.each do |voice|
      puts "Enqueue safe post content with voice: #{voice.id}"
      Delayed::Job.enqueue(Jobs::SafeContentJob.new(voice.id), { :priority => 1 })
    end
  end

  desc "update_source_service", "Update the source service for all the posts"
  def update_source_service
    'Post'.constantize.all.each do |post|
      if post.source_service.nil?
        post.source_service = 'Post'.constantize.detect_service(post.source_url)
        post.save(false)
      end
    end
  end
end