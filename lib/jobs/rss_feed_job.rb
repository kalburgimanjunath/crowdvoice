module Jobs
  class RssFeedJob < Struct.new(:voice_id)
    def perform
      # system "cd #{Rails.root} && RAILS_ENV=#{Rails.env} thor voices:feed_voices -v #{voice_id}"
      feeder = VoiceFeeder.feed_voice(voice_id)
    end
  end
end
