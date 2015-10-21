module Jobs
  class SafeContentJob < Struct.new(:voice_id)
    def perform
      voice = Voice.find(voice_id)
      voice.posts.each do |post|
        post.title = post.title.remove_unsafe
        post.description = post.description.remove_unsafe
        post.save(false)
      end
    end
  end
end