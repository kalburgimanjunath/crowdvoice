module Scrapers
  class Image

    attr_reader :url

    def initialize(url)
      @url = url
      raise Sources::Exceptions::UnrecognizedSource if scraper.nil?
    end

    def self.valid_url?(url)
      url =~ Sources::Flickr.regexp ||
        url =~ Sources::Twitpic.regexp ||
        url =~ Sources::Yfrog.regexp ||
        url =~ Sources::RawImage.regexp
    end

    def scraper
      @scraper ||=
        case url
          when Sources::Flickr.regexp then Sources::Flickr.new(APP_CONFIG[:flickr_key], url)
          when Sources::Twitpic.regexp then Sources::Twitpic.new(url)
          when Sources::Yfrog.regexp then Sources::Yfrog.new(APP_CONFIG[:yfrog_key], url)
          when Sources::RawImage.regexp then Sources::RawImage.new(url)
        end
    end
  end
end
