class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @project = Project.find(params[:project_id])
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
  # GET /events/1.xml
  def show
    @project = Project.find(params[:project_id])
    @event = @project.events.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @event.as_feature_hash }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
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
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @project = Project.find(params[:project_id])
    wkt = params[:event].delete(:geom)
    @event = @project.events.build(params[:event])
    @event.geom = Point.from_ewkt(wkt)

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
  # PUT /events/1.xml
  # def update
  #   @project = Project.find(params[:project_id])
  #   @event = @project.events.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @event.update_attributes(params[:event])
  #       format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /events/1
  # DELETE /events/1.xml
  # def destroy
  #   @event = Event.find(params[:id])
  #   @event.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(events_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
