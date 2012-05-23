class ApplicationController < ActionController::Base
  USERNAME, PASSWORD = "caritaspublic", "caritaspublic"

  protect_from_forgery
  # before_filter :staging_authentication
  before_filter :set_locale, :prepare_for_mobile
  before_filter :authenticate_user!
  before_filter :set_settings
  before_filter :setup_breadcrumbs, :only => [:index, :show, :edit, :new, :projects]

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => t(:unauthorized, :action => t(exception.action), :subject => t(exception.subject))
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404
  end

  def current_user_location_ids
    if current_user.settings.location.child_location_ids.blank?
      [current_user.settings.location.id.to_s]
    else
      [current_user.settings.location.id.to_s] + current_user.settings.location.child_location_ids.split('|')
    end
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

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def setup_breadcrumbs
    # TODO: refactor, will probably need to move to their own controllers 
    # esp. for nested resources
    if current_user and self.controller_name != 'events'
      add_crumb "Dashboard", '/'
      unless self.controller_name == 'dashboard'
        add_crumb self.controller_name.titleize, send("#{self.controller_name}_path") 
      end
      case self.action_name.to_s
      when 'show'
        add_crumb params[:id], send("#{self.controller_name.singularize}_path", params[:id])
      when 'edit'
        add_crumb "Editing #{params[:id]}"
      when 'index'
      else
        add_crumb self.action_name.to_s
      end
    end
  end

  def mobile_device?
    return false if request.format.to_s =~ /application\/json/i
    request.user_agent =~ /Mobile|webOS/
  end

  def prepare_for_mobile
    request.format = :mobile if mobile_device?
  end

  def set_settings
    @settings = current_user.settings if current_user
  end

  def staging_authentication
    return unless Rails.env.to_s == "production"
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end

end
