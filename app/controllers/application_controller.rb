

# This contains main views accessible to everyone
class ApplicationController < ActionController::Base
  include FlashCodes

  add_flash_types :success, :fail
  before_action :get_session_user, :set_status
  after_action :set_page_title

  protected

  def authorise
    unless logged_in?
      @status = :forbidden
      redirect_back_or_to(:root)
    end
  end

  def set_status
    @status = @status.present? ? @status : :ok
  end

  def get_session_user
    @current_user = User.find_by id: session[:user_id]
  end

  def set_page_title
    @page_title = @page_title + ' - ' + Rails.configuration.title if @page_title.present?
  end

  def logged_in?
    @current_user.present?
  end

  def admin?
    logged_in? ? @current_user.is_admin : false
  end

  def controller_of(url = root_url)
    puts Rails.application.routes.recognize_path(url).inspect
  end

end
