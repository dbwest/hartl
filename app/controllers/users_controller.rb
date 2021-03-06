class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]

  def index
    @users = User.all
  end

  def new
  	@user = User.new  	
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts
  end

  def edit
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      flash[:success] = "Welcome to the Sample App!"
      sign_in @user
      redirect_to @user
	  else
		  render 'new'
	  end
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "You have successfully updated your profile"
      sign_in @user
      redirect_to @user
    else
      flash[:error] = "error"
      redirect_to edit_user_url
    end
  end

  def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
  end
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end




end
