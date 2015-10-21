class TwitterSearch
  TIMEOUT = 10

  def self.search(criterial = nil)
    criterial ||= @criterial
    begin
      t = ::Twitter::Client.new
      t.search(criterial)
    rescue Timeout::Error, StandardError
      []
    end
  end

  def self.get_valid_urls(source = nil, last_tweet = nil)
    tweet_links = source.map do |tweet|
      if !last_tweet.nil? && (tweet.id.to_i <= last_tweet.to_i)
        Rails.logger.info "TwitterSearch: Reached last Tweet! stoping..."
        break
      end

      self.url_finder(tweet)
    end if source

    tweet_links = [] unless tweet_links
    tweet_links.flatten.compact
  end

  #Get an array of valid urls
  def self.url_finder(tweet)
    tweet.text.scan( /https?:\/\/[^ ]+/ ).map do |link|
      begin
        url = TwitterSearch.get_last_response_with_url(link)
        url = url[:url] if url
      rescue Timeout::Error, OpenURI::HTTPError, URI::InvalidURIError, SocketError, ArgumentError => e
        Rails.logger.error "TwitterSearch: Error fetching #{link} - #{e.inspect}"
      end
    end
  end

  # Get last URL by redirection
  def self.get_last_response_with_url(url, headers = {}, retries = 20, last_host = nil)
    raise ArgumentError, 'HTTP redirect too deep' if retries.zero?
    url = last_host.present? && !(url =~ /^https?:\/\//) ? "http://#{last_host}#{url}" : url
    url = URI.parse(url) unless url.is_a?(URI::HTTP)
    http = Net::HTTP.new( url.host || url.registry )
    http.read_timeout = TIMEOUT
    http.open_timeout = 2

    http.start do |http|
      response = http.request_get(url.request_uri, headers)
      case response
        when Net::HTTPSuccess
          {:response => response, :url => url.to_s}
        when Net::HTTPRedirection
          self.get_last_response_with_url(response['location'], headers, retries - 1, url.host)
        when Net::HTTPClientError
        when Net::HTTPServerError
      end
    end
  end

end
