#Controller in charge of creating and managing user sessions.
class SessionsController < ApplicationController
  layout 'admin'

  #Renders the form to create a new session.
  def new
  end

  #Authenticates the user and creates a new session
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      respond_to do |format|
        format.html { redirect_to admin_root_url }
        format.json { render :json => user, :status => :ok}
      end
    else
      flash.now.alert = t('flash.sessions.create.invalid_login')
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => {'base' => t('flash.sessions.create.invalid_login')}, :status => :not_found}
      end
    end
  end

  #Renders the form to reset the password
  def reset_password
    redirect_to admin_root_path if current_user
  end

  #Sends an email with the reset password instructions to the user
  def reset_password_notify
    user = User.find_by_email(params[:email])

    if user
      user.reset_token
      ::NotifierMailer.reset_password_instructions(user).deliver
      flash.now.notice = t('flash.sessions.reset_password_notify.email_sent')
    else
      flash.now.alert = t('flash.sessions.reset_password_notify.user_not_found')
    end

    render :reset_password
  end

  #Terminates the user session
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
