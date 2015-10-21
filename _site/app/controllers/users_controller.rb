class UsersController < ApplicationController
  respond_to :json, :only => [:create]

  layout 'admin', :only => [:reset_password, :update_password]

  #Creates a new user and notifies via e-mail. Responds to JSON.
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      ::NotifierMailer.sign_up_mail(@user).deliver
      status = :ok
    else
      status = :unprocessable_entity
    end
    respond_with(@user, :status => status, :content_type => "text/plain")
  end

  #Displays the reset form for the current `user_id` and
  #`reset_password_token`
  def reset_password
    @user = User.find_by_id_and_reset_password_token(params[:user_id], params[:reset_password_token])
  end

  #Updates the user password
  def update_password
    @user = User.find_by_id_and_reset_password_token(params[:user_id], params[:reset_password_token])

    if @user && @user.update_attributes(params[:user])
      @user.reset_token
      session[:user_id] = @user.id
      redirect_to admin_root_url
    else
      render :reset_password
    end
  end
end
