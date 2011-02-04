class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu(true)
  before_filter :set_locale
  
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def index
    flash[:notice] = t(:hello_flash)
    render :template => 'index'
  end
end
