class Admin::AnnouncementsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required, :except => [:index]
  before_filter :find_announcement, :only => [:edit, :update, :destroy]
  layout 'admin'

  #All announcements
  def index
    @announcements = Announcement.page(params[:page])
  end

  #Form to create a new announcement
  def new
    @announcement = Announcement.new
  end

  #Form to edit an announcement
  def edit
  end

  #Creates a new announcement
  def create
    @announcement = Announcement.new(params[:announcement])
    if @announcement.save
      redirect_to admin_announcements_path, :notice => t('flash.admin.announcements.create')
    else
      render :action => "new"
    end
  end

  #Updates an existing announcement
  def update
    if @announcement.update_attributes(params[:announcement])
      redirect_to admin_announcements_path, :notice => t('flash.admin.announcements.update')
    else
      render :action => "edit"
    end
  end

  #Destroys an announcement
  def destroy
    if @announcement.destroy
      redirect_to admin_announcements_path, :notice => t('flash.admin.announcements.destroy')
    else
      render :action => "edit"
    end
  end

  private

  #Finds an announcement given by `params[:id]` and sets it inside
  #`@announcement`
  def find_announcement
    @announcement = Announcement.find(params[:id])
  end
end
