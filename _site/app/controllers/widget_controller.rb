class WidgetController < ApplicationController
  before_filter :get_size_params, :only => [:show]

  #Shows a single voice
  def show

    limit = 50
    limit = params[:limit] if params[:limit] and params[:limit].to_i > 0

    if @scope_this = (params[:scope] != 'all')
      @voice = Voice.find_by_slug!(params[:id])
      @posts = @voice.posts.approved.limit(limit)
    else
      @voices = Voice.approved
    end
    @rtl = params[:rtl] == '1' ? true : false
    respond_to do |format|
      format.html
    end
  end

  private

  #Defines `@list_height_size`, `@post_image_size`, `@voice_image_size`,
  #`@list_width_size` and `@show_description` based on the size, width
  #and show_description parameters.
  def get_size_params
    @list_height_size = case params[:size]
                        when "small" then
                          "small-list"
                        when "medium" then
                          "medium-list"
                        when "tall" then
                          "tall-list"
                        end
    width_size = get_width(params[:width])

    case width_size
    when "small"
      @post_image_size = "42x42"
      @voice_image_size = "42x42"
      @list_width_size = "small-size"
    when "default"
      @post_image_size = "55x55"
      @voice_image_size = "65x65"
      @list_width_size = "default-size"
    end

    @show_description = !!(params[:show_description] && params[:show_description].to_s == "1")
  end

  #Returns either "default" or "small" based on the width sent to it.
  #@param [String] width the width parameter for widgets
  #@return [String] the width class, either "default" or "small"
  def get_width(width)
    size = "default"
    unless width.nil?
      if width == "small" || width.to_i <= 200
        size = "small"
      end
    end
    size
  end
end
