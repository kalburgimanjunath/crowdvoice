class Admin::SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required
  layout 'admin'

  #Lists all settings.
  def index
    @settings = Setting.all
  end

  #Updates all settings
  def update
    settings = (params[:posts].to_i >= 25) && Setting.update_settings(params)

    if settings
      redirect_to admin_settings_index_path, :notice => t('flash.admin.settings.update.notice')
    else
      render :action => "index", :locals => {:errors => t('flash.admin.settings.update.posts_per_page_error')}
    end
  end

  private

  #Finds a setting from `params[:id] and sets it inside `@setting`
  def find_setting
    @setting = Setting.find(params[:id])
  end
end
