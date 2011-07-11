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
    # FIXME: Bad smell - part of this logic is in applications_controller
    if current_user.settings.nil?
      @settings = Settings.new(:user_id => current_user.id)
      @settings.save
    else
      @settings = current_user.settings
    end

    @locations ||= Location.all(:order => 'created_at asc', :select => ["id", "admin_level", "name"]) # TODO: update syntax
    if @settings.location.blank?
      @pre_populate_location =  []
    else
      @pre_populate_location = [{:id => @settings.location_id, :name => @settings.location.name}]
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
