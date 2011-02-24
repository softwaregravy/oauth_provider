# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#require 'oauth/request_proxy/rack_request'
#require 'oauth/controllers/application_controller_methods'


class ApplicationController < ActionController::Base
#  include OAuth::Controllers::ApplicationControllerMethods
  helper :all
  helper_method :current_user_session, :current_user, :fetch_logged_in_user, :logged_in?, :do_oauth, :require_oauth
  filter_parameter_logging :password, :password_confirmation
  
  private

  def my_two_legged 
    begin
      if ClientApplication.verify_request(request) do |request_proxy|
        @client_application = ClientApplication.find_by_key(request_proxy.consumer_key)
        # return the token secret and the consumer secret
        [nil, @client_application.secret]
      end
      !@client_application.nil? 
      else
        false
      end
    rescue
      false
    end
  end

  def current_client_application 
    return @client_application if defined?(@client_application)
  end 

  def require_oauth 
      debugger
    unless my_two_legged
      head 401 
      return false 
    end 
  end 

  def require_user_or_oauth 
    if request.format.to_sym == :json 
      require_oauth
    elsif request.format.to_sym == :html
      require_user 
    else 
      logger.warn "Invalid request format" 
      false
    end 
  end 


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def fetch_logged_in_user 
    current_user 
  end 

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def logged_in?
    return !current_user.nil?
  end 

  def login_required 
    return true if logged_in?
    store_location 
    redirect_to new_user_session_url 
    return false 
  end 

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
