require File.expand_path('config/environment.rb')

class Voices < Thor
  desc 'update_feed_voices','Updated all the voices with the new content from the feeds'
  def update_feed_voices
    Voice.all.each do |voice|
      puts "Enqueue update voice from feed with voice: #{voice.id}"
      Delayed::Job.enqueue Jobs::RssFeedJob.new(voice.id)
    end
  end

  desc 'feed_voices','Feeds the voice with new content'
  method_option :voice_id, :required => false, :aliases => "-v", :type => :string
  def feed_voices
    # Logger
    logger = Logger.new("#{Rails.root}/log/feed.log")

    # Fetch all voices
    Rails.logger.info "\nStarting to fetch all voices (#{Time.now})..."
    if options[:voice_id].blank?
      VoiceFeeder.feed_voices
    else
      VoiceFeeder.feed_voice(options[:voice_id])
    end

    Rails.logger.info "Finished Fetching RSS feeds..."
  end
end