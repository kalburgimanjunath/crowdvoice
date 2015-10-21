#This controller is in charge of the index page.
class HomeController < ApplicationController
  layout 'page'

  #Renders the index in html, json or rss
  def index
    @featured = Voice.featured #NOTE: Is this not already set?
    @columns = [[], [], []]
    @featured.each_with_index do |f, i|
      pos = i % 3
      @columns[pos] << f
    end

    respond_to do |format|
      format.html
      format.json { render :json => Voice.all }
      format.rss {@all_voices = Voice.featured }
    end
  end
end
