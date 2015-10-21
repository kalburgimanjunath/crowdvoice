class VoicesController < ApplicationController
  cache_sweeper :static_page_sweeper, :only => [:create, :update, :destroy]
  respond_to :html, :rss, :js, :json, :only => [:show]

  caches_page :show, :if => Proc.new { |c| c.request.format.rss? }

  #Redirects to show the voices
  def index
    redirect_to admin_voices_path
  end

  #Shows a single voice
  def show
    @voice = Voice.find_by_slug!(params[:id])

    #Selects which filters to use
    filters = params[:filters] ? params[:filters].split(',') : ['image', 'video', 'link']

    #Get the posts (approved or unapproved, depending if in moderation
    #or not) then filter by date and finally split per page.
    scope = (params[:mod] ? @voice.posts.unapproved : @voice.posts.approved).by_type(filters)
    scope = scope.where("created_at <= ?", Date.parse(params[:start]) + 1) if params[:start]
    @posts = scope.page(params[:page]).per(Setting.posts_per_page.to_i)
    if request.format.html? || request.format.js?
      @next_page = (params[:page].nil? ? 1 : params[:page].to_i) + 1
      @posts_count = scope.count
    end
    if request.format.html?
      #Get votes, twitter search and the timeline
      @votes = get_votes
      @twitter = TwitterSearch.search(@voice.twitter_search) if @voice.twitter_search
      @timeline = scope.select(:created_at).group_by { |p| p.created_at.beginning_of_day.to_date}.keys.group_by{ |date| date.year}
      @timeline = ActiveSupport::OrderedHash[@timeline.sort]
    end

    if params[:post]
      post = @voice.posts.find(params[:post])
      unless @posts.include?(post)
        @posts << post
      end
    end

    respond_with(@posts, :location => @voice)
  end

  #Enqueues a job to fetch an rss feed and redirects to index.
  def fetch_feeds
    Delayed::Job.enqueue Jobs::RssFeedJob.new
    flash[:notice] = t('flash.voices.fetch_feeds.fetching')
    redirect_to :action => 'index'
  end

  #Gets the voices with location. Responds to JSON.
  def locations
    voices = Voice.where("latitude IS NOT NULL AND TRIM(latitude) <> '' AND longitude IS NOT NULL AND TRIM(longitude) <> ''").group_by(&:location).map do |location, voices|
      voices = voices.map { |v| {:slug => v.slug, :title => v.title, :latitude => v.latitude, :longitude => v.longitude } }
      {:location => location, :voices => voices}
    end
    render :json => voices
  end

  private

  #Get the votes for the current posts.
  def get_votes
    ids = @posts.map(&:id)
    votes = Vote.where("post_id in (:ids) and ((user_id IS NOT null and user_id = :user_id) or (ip_address = :ip))", {:ids => ids, :user_id => current_user, :ip => request.remote_ip})
    votes.map{|vote| {:id => vote.post_id.to_s, :positive => (vote.rating > 0) ? true : false } }
  end
end
