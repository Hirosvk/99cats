class UsersController < ApplicationController
  before_action :require_current_user!, except: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      msg = UserMailer.welcome_email(user)
      msg.deliver
      log_in(user)
      redirect_to cats_url
    else
      flash[:user_create_errors] = user.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
  end

private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end

end
