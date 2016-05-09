class UsersController < ApplicationController
  before_action :logged_in?, only: [:show]

  def index
    @users = User.all
    render :index
  end

  def new
    @user = User.new
    render :new
  end

  def edit
    #friendly_id requires a find and not a find_by_id
    @user = User.friendly.find(params[:id])
    render :edit
  end

  def create
    @user = User.create(user_params)
    if @user.avatar == ""
      # Adds default avatar image if no image is uploaded
      @user.avatar = "your_avatar_image.png"
    end
    if @user.save
      login(@user)
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to new_user_path
    end
  end

  def show
    @user = User.friendly.find(params[:id])
    @posts = @user.posts.all
    render :show
  end

  def update
    user = User.friendly.find(params[:id])
    user.update(user_params)
    redirect_to user_path
  end

  def self.confirm(params)
    @user = User.find_by({email: params[:email]})
    @user.try(:authenticate, params[:password])
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :current_city, :avatar)
  end

end
