class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :require_authentication

  helper_method :current_user, :signed_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def require_authentication
    return if signed_in?

    redirect_to login_path, alert: "You must be signed in to do that."
  end

  def require_series_producer(series)
    return if series.producer?(current_user)

    redirect_to series_path(series), alert: "You must be a producer of this series to do that."
  end

  def require_series_executive_producer(series)
    return if series.executive_producer?(current_user)

    redirect_to series_path(series), alert: "Only the Executive Producer can manage producers."
  end
end
