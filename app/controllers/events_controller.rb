class EventsController < ApplicationController
  before_filter :setup_breadcrumbs, :only => [:index, :show, :edit, :new, :projects]
  # GET /events
  def index
    @project = Project.find(params[:project_id])
    @events = @project.events.order('updated_at desc')

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        render(:layout => false, :json =>  {
            :type => "FeatureCollection",
            :features => @events.map(&:as_feature_hash) }
        )
      end
    end
  end

  # GET /events/1
  def show
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])

    respond_to do |format|
      format.html{
        if params[:zoombox]
          render 'show', :layout => 'plain'
        end
      } # show.html.erb
      format.json  { render :json => @event.as_feature_hash }
    end
  end

  # GET /events/new
  def new
    authorize! :new, Event
    @project = Project.find(params[:project_id])
    @event = Event.new
    # 3.times { @event.images.build }

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  # GET /events/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])
    # 3.times { @event.images.build }
    authorize! :edit, @event
  end

  # POST /events
  def create
    @project = Project.find(params[:project_id])
    #wkt = params[:event].delete(:geom)
    params[:event][:geom] = 'POINT(71.46972219999998 30.19777779999999 0)' unless params[:event][:geom]
    @event = @project.events.build(params[:event])
    #@event.geom = Point.from_ewkt(wkt) rescue nil # TODO: move to virtual attribute
    #geom = Event::GEOM_FACTORY.parse_wkt(wkt)
    #ap geom
    #@event.geom = geom
    @event.user = current_user
    authorize! :create, @event

    respond_to do |format|
      if @event.save
        Caritas::WebSocket.queue_for_broadcast(@event.as_feature_hash)
        format.html { redirect_to(project_url(@project, :anchor => "event_#{@event.id}"), :notice => 'Event was successfully created.') }
        format.mobile { redirect_to(@project) }
      else
        format.html { render :action => "new", :error => 'Please ensure the location has been geo-coded before saving.' }
        format.mobile  { render :action => "new" }
      end
    end
  end

  # PUT /events/1
  def update
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])
    authorize! :update, @event

    #wkt = params[:event].delete(:geom)
    params[:event][:geom] = 'POINT(71.46972219999998 30.19777779999999 0)' unless params[:event][:geom]
    # begin
    # FIXME: itn't working for ewkb
    #@event.geom = wkt
    #@event.save
    # rescue GeoRuby::SimpleFeatures::EWKTFormatError
    #   @event.geom = Point.from_ewkb(wkt)
    # end

    params[:event][:partner_ids] ||= []
    params[:event][:sector_ids] ||= []

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(project_url(@project, :anchor => "event_#{@event.id}"), :notice => 'Activity was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /events/1
  def destroy
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])
    authorize! :destroy, @event

    @event.destroy

    respond_to do |format|
      format.html { redirect_to(project_url(@project)) }
    end
  end
private

def setup_breadcrumbs
  if current_user
    add_crumb "Dashboard", '/'
    add_crumb "Projects", projects_path
    add_crumb params[:project_id], project_path(params[:project_id])
    add_crumb "Activities" #, project_events_path(params[:project_id])
    add_crumb params[:id] #, project_event_path(params[:project_id],params[:id])
  end
end
end
