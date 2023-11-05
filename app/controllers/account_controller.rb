## View controller
class AccountController < ApplicationController

  REDIRECT_TIME = 5
  SHIT_PASSWORDS = %w[password pass 123 12345]

  before_action :authorise, except: [:login, :register, :logout]
  before_action :redirect_user_out, only: [:login, :register]
  before_action :set_redirect_out

  def login
    @page_title = 'Login'
    if request.post?
      begin
        @user = User.new(login_params)
        user = User.find_by username: @user.username
        if user.nil?
          # Username not found
          flash.now[:fail] = FlashCodes::NO_USER
          @status = :not_found
        elsif user.authenticate(login_params[:password])
          # Successful login
          session[:user_id] = user.id
          @current_user = user
          flash.now[:success] = FlashCodes::LOGIN_YAY
          redirect_out
          @status = :created
        else
          # Invalid password
          flash.now[:fail] = FlashCodes::WRONG_PASS
          @status = :unauthorized
        end
      rescue
        flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
        @status = :internal_server_error
      end
    end
    render status: @status
  end

  def logout
    @status = :unauthorized unless @current_user.present?
    reset_session
    redirect_out
    render status: @status
  end

  def register
    if request.post?
      begin
        if register_params[:password] != register_params[:confirm_password]
          flash.now[:fail] = FlashCodes::PASS_NOT_MATCH
          # Just to keep it to the form
          @user = User.new(register_params.except(:password, :confirm_password))
          @status = :not_acceptable
        elsif SHIT_PASSWORDS.include? register_params[:password]
          flash.now[:fail] = FlashCodes::SHIT_PASS
          @status = :not_acceptable
          @user = User.new(register_params.except(:password, :confirm_password))
        else
          @user = User.new(register_params.except(:confirm_password))
          if @user.valid?
            if @user.save
              @current_user = @user
              session[:user_id] = @current_user.id
              @status = :created
              flash.now[:success] = FlashCodes::REGISTER_YAY
              redirect_out
            else
              flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
              @status = :internal_server_error
            end
          else
            @user.errors.each do |e|
              flash.now[:fail] = FlashCodes::USER_TAKEN  if e.type == :taken
            end
            @status = :not_acceptable
          end
        end

      rescue StandardError => e
        puts e.message
        flash.now[:fail] = FlashCodes::INTERNAL_SERVER_ERROR
        @status = :internal_server_error
      end
    end
    @page_title = 'Register'
    render status: @status
  end

  def settings

  end

  def delete
  end

  private

  def login_params
    params.require(:user).permit(:username, :password)
  end

  def register_params
    params.require(:user).permit(:username, :password, :confirm_password, :fullname, :email)
  end

  # Redirect user out if already logged in
  def redirect_user_out
    if logged_in?
      flash[:alert] = FlashCodes::ALREADY_LOGGED_IN unless flash[:success].present?
      @status = :forbidden
      redirect_out
    end
  end

  def authorise
    super unless flash.present?
  end

  def set_redirect_out
    # Jesus Christ
    if session[:redirect_url].blank? || session[:redirect_path].blank?
      url = root_url
      path = root_path
      if request.referer.present?
        _url = request.referer
        uri = URI::parse(_url)
        if uri.host.equal? request.host
          begin
            if Rails.application.routes.recognize_path(uri.path)[:controller] != controller_name
              url = _url
              path = uri.path
            end
          rescue ActionController::RoutingError
            # Ignored, for now
          end
        end
      end
      session[:redirect_url] = url
      session[:redirect_path] = path
    end
    @redirect_url = session[:redirect_url]
    @redirect_path = session[:redirect_path]
  end

  def redirect_out
    session[:redirect_url] = nil
    session[:redirect_out] = nil
    @redirect_time = REDIRECT_TIME
    @redirect_out = true
  end
end
