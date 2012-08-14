class Admin::VoicesController < ApplicationController
  cache_sweeper :static_page_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :voices_sweeper, :only => [:create, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :find_voice, :only => [:edit, :update, :destroy]
  layout 'admin'

  #Lists all voices, with pagination
  def index
    @voices = Kaminari.paginate_array(scoped_voice.all).page(params[:page])
  end

  #Form to create a new voice
  def new
    @voice = Voice.new
  end

  #Creates a new voice
  def create
    @voice = build_scoped_voice(params[:voice])
    @voice.user_id = current_user.id
    if @voice.save
      User.where(:is_admin => true).each{|user| ::NotifierMailer.voice_submitted(@voice.id, user.email).deliver }
      ::NotifierMailer.voice_has_been_submitted(@voice.id).deliver
      redirect_to @voice, :notive => t('flash.admin.voices.create')
    else
      render :new
    end
  end

  #Form to edit a voice
  def edit
  end

  #Updates a single voice
  def update
    if @voice.update_attributes(params[:voice])
      redirect_to admin_voices_path, :notice => t('flash.admin.voices.update')
    else
      render :edit
    end
  end

  #Destroys a single voice
  def destroy
    @voice.destroy
    redirect_to admin_voices_path, :notice => t('flash.admin.voices.destroy')
  end

  private

  #Finds a voice based on `params[:id]` and sets it inside `@voice`
  def find_voice
    @voice = scoped_voice.find_by_slug!(params[:id])
  end

  #Creates a voice for the user if he is not admin, and a voice
  #without a user if the current user is admin.
  def build_scoped_voice(*args)
    if current_user and current_user.is_admin?
      Voice.new(*args)
    else
      current_user.voices.build(*args)
    end
  end

  #Shows all the voices if the user is an admin, only the user's voices
  #otherwise.
  def scoped_voice
    if current_user && current_user.is_admin?
      Voice.order('created_at desc')
    else
      current_user.voices.order('created_at desc')
    end
  end
end
