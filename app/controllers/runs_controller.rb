class RunsController < ApplicationController

  before_filter :set_content_type, :only => :show
  before_filter :require_user #unless ::RAILS_ENV == 'development'

  def index
   # person = Person.find(session[:user_id])
   # person = Person.find(1)
   #  groups = person.groups #.find(:all, :order => 'approved, name')
   #  @runs  = groups.collect do |group|
   #    group.runs
   #  end
    @runs = Run.find(:all)
  end

  def show
    @run = Run.find(params[:id])
  end
  
  def load_data
    @run = Run.find(params[:id])
  end

  def new
    @run = Run.new
  end

  def toggle_point
    flux = Flux.find(params[:id])
    if flux.incubation.run.approved
      render :nothing => true
      return
    end
          
 #   if (flux.incubation.run.group.people.any? {|p| p.id == session[:user_id]})
      flux.toggle_point(params[:seconds])

      render :partial => 'flux', :locals => {:flux => flux}
  #  else
  #    render :nothing => true
  #  end
  end

  def create
    run_params = params[:run]
    @run = Run.new()
    # p session[:user_id]
    # @run.group = Person.find(session[:user_id]).default_group
    @run.setup=run_params[:file].read
    @run.comment = run_params[:comment]
    respond_to do |format|
      if @run.save
        flash[:notice] = 'Run was sucessfully created'
        format.html {redirect_to runs_url}
      else
        format.html {render :action => 'new'}
      end
    end
  end

  def data
    @run = Run.find(params[:id])
    file = params['file']['name'].read
    @run.data=file

    respond_to do |format| 
      if @run.save
        flash[:notice] = 'Run was successfully created.'
        format.html {redirect_to runs_url}
      else
        format.html {render :action => 'load_data'}
      end
    end
  end

  def export_xls
    @run = Run.find(params[:id])
    headers['Content-Type'] = "application/vnd.ms-excel" 
    headers['Content-Disposition'] = %Q{attachment; filename="#{@run.name}.xls"}
    headers['Cache-Control'] = ''

    render_without_layout
  end

  def delete_data
    @run = Run.find(params[:id])
    @run.samples.each do | sample |
      sample.ppm = nil
      sample.response = nil
      sample.excluded = false
      sample.save
    end
    redirect_to :action => :index
  end

  def edit
    @run = Run.find(params[:id])
  end

  def update
    @run  = Run.find(params[:id])
    @run.approved = true
    if @run.save
      flash[:notice] = 'Run was successfully updated.'
      redirect_to :action => 'show', :id => @run
    else
      render :action => 'edit'
    end
  end

  def approve
    @run = Run.find(params[:id])
    @run.toggle :approved
    @run.save
    redirect_to runs_url
  end


  def destroy
    @run = Run.find(params[:id])
    @run.destroy
    redirect_to runs_url
  end

  private
  def set_content_type
    headers["Content-Type"] = 'text/xml; charset=utf-8'
  end

  def check_person
    @run = Run.find(params[:id])
    @run.group.people.any? {|p| p.id  ==  session[:user_id]}
  end
end
