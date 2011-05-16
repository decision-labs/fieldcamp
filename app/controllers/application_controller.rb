class ApplicationController < ActionController::Base
  USERNAME, PASSWORD = "caritaspublic", "caritaspublic"

  protect_from_forgery
  before_filter :staging_authentication
  before_filter :set_locale, :prepare_for_mobile
  before_filter :authenticate_user!, :except => ['show', 'index']
  before_filter :set_location_scope

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t(:unauthorized, :action => t(exception.action), :subject => t(exception.subject))
  end

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    # logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  private
  def mobile_device?
    return false if request.format.to_s =~ /application\/json/i
    request.user_agent =~ /Mobile|webOS/
  end

  def prepare_for_mobile
    request.format = :mobile if mobile_device?
  end

  def set_location_scope
    unless (current_user.nil? || current_user.settings.nil?)
      @settings = current_user.settings
      unless @settings.location.nil?
        @current_user_location_ids = current_user.settings.location.children.collect(&:id)
        @current_user_location_ids << current_user.settings.location_id
      end
    end
  end

  def staging_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end

end
