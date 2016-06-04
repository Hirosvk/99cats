class SessionsController < ApplicationController
  before_action :require_current_user!, except: [:new, :create]

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password],
    )

    if !user.nil?
      log_in(user)
      redirect_to cats_url
    else
      flash[:login_errors] << "username or password is wrong."
      render :new
    end

  end

  def destroy
    log_out
    redirect_to cats_url
  end

end
