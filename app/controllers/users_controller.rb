class UsersController < ApplicationController
  skip_before_action :require_authentication, only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    set_admin_if_permitted

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    permitted = [ :email, :password, :password_confirmation ]
    permitted << :admin if current_user&.admin?
    params.require(:user).permit(permitted)
  end

  def set_admin_if_permitted
    return unless params[:user].key?(:admin)
    return unless current_user&.admin?

    @user.admin = ActiveModel::Type::Boolean.new.cast(params[:user][:admin])
  end
end
