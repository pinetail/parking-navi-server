class ShopsVisitsController < ApplicationController
  # GET /shops_visits
  # GET /shops_visits.xml
  def index
    @shops_visits = ShopsVisit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shops_visits }
    end
  end

  # GET /shops_visits/1
  # GET /shops_visits/1.xml
  def show
    @shops_visit = ShopsVisit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shops_visit }
    end
  end

  # GET /shops_visits/new
  # GET /shops_visits/new.xml
  def new
    @shops_visit = ShopsVisit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shops_visit }
    end
  end

  # GET /shops_visits/1/edit
  def edit
    @shops_visit = ShopsVisit.find(params[:id])
  end

  # POST /shops_visits
  # POST /shops_visits.xml
  def create
    @shops_visit = ShopsVisit.new(params[:shops_visit])

    respond_to do |format|
      if @shops_visit.save
        format.html { redirect_to(@shops_visit, :notice => 'Shops visit was successfully created.') }
        format.xml  { render :xml => @shops_visit, :status => :created, :location => @shops_visit }
        format.json { render :json => @shops_visit, :status => :created, :location => @shops_visit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shops_visit.errors, :status => :unprocessable_entity }
        format.json  { render :json => @shops_visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shops_visits/1
  # PUT /shops_visits/1.xml
  def update
    @shops_visit = ShopsVisit.find(params[:id])

    respond_to do |format|
      if @shops_visit.update_attributes(params[:shops_visit])
        format.html { redirect_to(@shops_visit, :notice => 'Shops visit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shops_visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shops_visits/1
  # DELETE /shops_visits/1.xml
  def destroy
    @shops_visit = ShopsVisit.find(params[:id])
    @shops_visit.destroy

    respond_to do |format|
      format.html { redirect_to(shops_visits_url) }
      format.xml  { head :ok }
    end
  end
end
