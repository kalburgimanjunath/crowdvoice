class VoiceFeeder
  def self.feed_voice(voice_id)
    voice = Voice.find(voice_id)
    voice.rss_feed.blank? ? Rails.logger.info("Rss empty.") : fetch_rss(voice)
    voice.twitter_search.blank? ? Rails.logger.info("Twitter search empty (shouldn't be)."): fetch_tweets(voice)
  end

  def self.feed_voices
    Voice.all.each do |voice|
      voice.rss_feed.blank? ? Rails.logger.info("Rss empty.") : fetch_rss(voice)
      voice.twitter_search.blank? ? Rails.logger.info("Twitter search empty (shouldn't be).") : fetch_tweets(voice)
    end
  end

  # Scrappe the rss url and get all the valid links for create a post for the specific voice
  def self.fetch_rss(voice)
    @last_rss = ''
    Scrapers::Sources::Rss.new(voice.rss_feed).scrape do |rss, last_rss|
      @result = rss.map{|url| voice.posts.new(:source_url => url).save }
      @rss, @last_rss = rss, last_rss
    end
    voice.update_attribute(:last_rss, @last_rss) if @last_rss && (voice.last_rss.nil? || (voice.last_rss <=> @last_rss) < 0)
    voice.expire_cache
  end

  # Gets the url valid from a search on twitter
  def self.fetch_tweets(voice)
    source = TwitterSearch.search(voice.twitter_search)
    last_tweet = source.last[:id] unless (source.nil? || source.empty?)
    urls = TwitterSearch.get_valid_urls(source, voice.last_tweet)
    urls.map{ |url| voice.posts.new(:source_url => url).save }
    voice.update_attribute(:last_tweet, last_tweet) if last_tweet && (voice.last_tweet.nil? || (voice.last_tweet.to_i <=> last_tweet.to_i) < 0)
    voice.expire_cache
  end
end
