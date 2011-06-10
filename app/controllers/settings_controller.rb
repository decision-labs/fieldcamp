class SettingsController < ApplicationController
  before_filter :authenticate_user!
  def show
    if current_user.settings.nil?
      @settings = Settings.new(:user_id => current_user.id)
      @settings.save
    else
      @settings = current_user.settings
    end
    respond_to do |format|
      format.html{}
      format.json{render :json => @settings.attributes.to_json}
    end
  end

  def edit
    @locations ||= Location.all(:order => 'created_at asc', :select => ["id","admin_level", "name"])
    if current_user.settings.nil?
      @settings = Settings.new(:user_id => current_user.id)
      @settings.save
    else
      @settings = current_user.settings
    end
  end

  def update
    @settings = current_user.settings
    respond_to do |format|
      if @settings.update_attributes(params[:settings])
        format.html{ redirect_to settings_url, :notice => t(:settings_update_success_message) }
      else
        format.html{ render :action => 'edit', :notice => t(:settings_update_failure_message) }
      end
    end
  end

end
