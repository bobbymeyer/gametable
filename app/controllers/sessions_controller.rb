class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
  end

  def create
    session_params = params.fetch(:session, {})
    user = User.authenticate_by(email: session_params[:email], password: session_params[:password])

    if user
      session[:user_id] = user.id
      redirect_to root_path, notice: "Signed in successfully."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Signed out successfully."
  end
end
