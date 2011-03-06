class EventsController < ApplicationController
  # GET /events
  def index
    @project = Project.find(params[:project_id], :order => 'updated_at DESC')
    @events = @project.events

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
      format.html # show.html.erb
      format.json  { render :json => @event.as_feature_hash }
    end
  end

  # GET /events/new
  def new
    authorize! :new, Event
    @project = Project.find(params[:project_id])
    @event = Event.new

    respond_to do |format|
      format.html
      format.mobile
    end
  end

  # GET /events/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])
    authorize! :edit, @event
  end

  # POST /events
  def create
    @project = Project.find(params[:project_id])
    wkt = params[:event].delete(:geom)
    @event = @project.events.build(params[:event])
    @event.geom = Point.from_ewkt(wkt)
    @event.user = current_user
    authorize! :create, @event

    respond_to do |format|
      if @event.save
        Caritas::WebSocket.queue_for_broadcast(@event.as_feature_hash)
        format.html { redirect_to(@project, :notice => 'Event was successfully created.') }
        format.mobile { redirect_to(@project) }
      else
        format.html { render :action => "new" }
        format.mobile  { render :action => "new" }
      end
    end
  end

  # PUT /events/1
  def update
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])
    authorize! :update, @event

    wkt = params[:event][:wkt]
    @event.geom = Point.from_ewkt(wkt)

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(project_url(@project), :notice => 'Event was successfully updated.') }
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
end
