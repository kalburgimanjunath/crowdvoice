class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin_required
  before_filter :find_user, :only => [:edit, :show, :update, :destroy]
  layout 'admin'

  #Lists all users
  def index
    @users = User.page(params[:page])
  end

  #Show a single user
  def show
  end

  #Form to create a new user
  def new
    @user = User.new
  end

  #Form to edit a user
  def edit
  end

  #Creates a new user
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to admin_users_path, :notice => t('flash.admin.users.create')
    else
      render :action => "new"
    end
  end

  #Updates the attributes of a single user
  def update
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path, :notice => t('flash.admin.users.update')
    else
      render :action => "edit"
    end
  end

  #Destroys a user
  def destroy
    if @user.destroy
      redirect_to admin_users_path, :notice => t('flash.admin.users.destroy')
    else
      render :action => "edit"
    end
  end

  private

  #Finds a single user from `params[:id]` and sets it inside `@user`
  def find_user
    @user = User.find(params[:id])
  end
end
