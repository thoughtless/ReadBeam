class EdocsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :clean_params, :only => [:create, :update]

  # GET /edocs
  # GET /edocs.json
  def index
    @edocs = find_edocs

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @edocs }
    end
  end

  # GET /edocs/1
  # GET /edocs/1.json
  def show
    @edoc = find_edoc(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edoc }
    end
  end

  # GET /edocs/new
  # GET /edocs/new.json
  def new
    @edoc = Edoc.new

    @all_sources = Source.all

    # This param is available after user selected a source to clone
    if params[:source]
      @source = Source.find(params[:source]['id'])

      @edoc.title          = @source.title
      @edoc.description    = @source.description
      @edoc.conversion     = @source.conversion
      @edoc.timezone       = @source.timezone
      @edoc.schedule       = @source.schedule
      @edoc.recipe_name    = @source.recipe_name
      @edoc.requires_login = @source.requires_login
      @edoc.language       = @source.language
      @edoc.source_id      = @source.id
    end

    if current_user
      if current_user.edocs.size > 2
        flash[:error] = "Please - for now - don't create more than three eDocs. Thank you."
        redirect_to edocs_path
        return
      end

      @edoc.format = current_user.format
      @edoc.device = current_user.device
      @edoc.is_mailed      = true

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @edoc }
      end
    else
      flash[:error] = "Please log in to access this page."
      redirect_to root_path
    end
  end

  # GET /edocs/1/edit
  def edit
    @edoc = find_edoc(params[:id])
  end

  # POST /edocs
  # POST /edocs.json
  def create
    @edoc = current_user.edocs.build(params[:edoc], :as => (:admin if current_user.is_admin?))

    respond_to do |format|
      if @edoc.save
        format.html { redirect_to edocs_path, notice: 'eDoc was successfully created.' }
        format.json { render json: @edoc, status: :created, location: @edoc }
      else
        @all_sources = Source.all
        format.html { render action: "new" }
        format.json { render json: @edoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /edocs/1
  # PUT /edocs/1.json
  def update
    @edoc = find_edoc(params[:id])

    respond_to do |format|
      if @edoc.update_attributes(params[:edoc], :as => (:admin if current_user.is_admin?))
        format.html { redirect_to edocs_path, notice: 'eDoc was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @edoc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edocs/1
  # DELETE /edocs/1.json
  def destroy
    @edoc = find_edoc(params[:id])
    @edoc.destroy

    respond_to do |format|
      format.html { redirect_to edocs_url }
      format.json { head :ok }
    end
  end

  def log
    @edoc = find_edoc(params[:edoc_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edoc }
    end
  end

  def mail
    edoc = find_edoc(params[:edoc_id])
  	UserMailer.send_edoc(edoc).deliver
  	flash[:info] = "Just sent out the eDoc to #{edoc.owner.distribution_email}. Enjoy!"
    redirect_to :edocs
  end

  def print
    edoc = find_edoc(params[:edoc_id])
    edoc.set_next_run_to_now
    edoc.update_attribute(:has_error, false)
    
    flash[:info] = "Conversion will be run asap."
    redirect_to :edocs
  end

  def toggle_mailing
    @edoc = find_edoc(params[:edoc_id])
    @edoc.toggle(:is_mailed)
    @edoc.is_mailed? ? flash[:info] = "Now mailing on schedule. Next mailing #{Time.at(@edoc.next_run).utc}" : flash[:info] = "There you have it. Mailing on schedule stopped."
    @edoc.save
    redirect_to :edocs
  end
  
  def download
    @edoc = find_edoc(params[:edoc_id])
    send_file @edoc.file_url, :type => Edoc::MIME_TYPE[@edoc.format], :disposition => 'attachment', :filename => "#{@edoc.recipe_name}.#{@edoc.format}"
  end
  
  protected
  
  def clean_params
    # Remove recipe name when a recipe has been uploaded
    params[:edoc].delete('recipe_name') if params[:edoc].has_key?('tmp_recipe')
    # Remove has_private_recipe attribute if it has not been set been set
    params[:edoc].delete('has_private_recipe') if params[:edoc].has_key?('has_private_recipe') && params[:has_private_recipe] = ''
  end
  
  def find_edoc(edoc_id)
    if current_user.is_admin?
      Edoc.find(edoc_id)
    else
      current_user.edocs.find(edoc_id)
    end
  end
  
  def find_edocs
    if current_user.is_admin?
      Edoc.where("has_error = 't' OR (has_private_recipe = 't' AND is_approved != 't')").order("created_at DESC")
    else
      current_user.edocs.order("created_at DESC")
    end
  end
end