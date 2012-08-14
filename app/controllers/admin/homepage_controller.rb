class Admin::HomepageController < ApplicationController
  layout 'admin'
  cache_sweeper :voices_sweeper, :only => [:update]

  #Shows voices for reordering in the homepage
  def show
    @voices = Voice.featured
  end

  #Changes the order of voices in the homepage
  def update
    @voices = Voice.featured
    @voices.each do |voice|
      voice.home_position = params[:voice].index(voice.id.to_s) + 1
      voice.save
    end
    render :nothing => true, :status => :ok
  end
end
