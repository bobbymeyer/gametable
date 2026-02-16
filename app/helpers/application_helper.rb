module ApplicationHelper
  def app_name
    Rails.application.config.app_name
  end

  def default_page_title
    "#{app_name} — AI Gametable"
  end
end
