require 'rd_person'

class LeadsController < ApplicationController
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  # GET /leads
  # GET /leads.json
  def index
    @leads = Lead.all
  end

  # GET /leads/1
  # GET /leads/1.json
  def show
  end

  # GET /leads/new
  def new
    @lead = Lead.new
  end

  # GET /leads/1/edit
  def edit
  end

  # POST /leads
  # POST /leads.json
  def create
    @lead = Lead.new(lead_params)

    @people = set_lead_rd_person
    @client = config_rd_person

    respond_to do |format|
      begin
        #if @client.create(@people)
        if Resque.enqueue(CreatePersonJob, @client, @people)
          if @lead.save
            format.html { redirect_to @lead, notice: 'Lead was successfully created.' }
            format.json { render :show, status: :created, location: @lead }
          else
            format.html { render :new }
            format.json { render json: @lead.errors, status: :unprocessable_entity }
          end
        else
          format.html { render :new }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      rescue
        format.html { render :new }
        format.json { render json: Resque.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leads/1
  # PATCH/PUT /leads/1.json
  def update
    respond_to do |format|
      if @lead.update(lead_params)
        format.html { redirect_to @lead, notice: 'Lead was successfully updated.' }
        format.json { render :show, status: :ok, location: @lead }
      else
        format.html { render :edit }
        format.json { render json: @lead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leads/1
  # DELETE /leads/1.json
  def destroy
    @lead.destroy
    respond_to do |format|
      format.html { redirect_to leads_url, notice: 'Lead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lead
      @lead = Lead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lead_params
      params.require(:lead).permit(:name, :last_name, :email, :company, :job_title, :phone, :website)
    end

    def config_rd_person
      #@client = SalesforceClient.new('', '', '', '', '')

      @client = SalesforceClient.new('thecaiogama@gmail.com', 'asdfg123', 'm5nzl1Ri3CdsK0e6d7hnfQ43c',
                                  '3MVG9xOCXq4ID1uEFUtg9aAbz6tVJQmBEjIi9_yUVbJ1VWIEHA6Jmia8rBxnd2CRW5agxrWFod4TabSeq4fx1',
                                  '832106501026385647')
    end

    def set_lead_rd_person
      @people = Person.new(@lead.name, @lead.last_name, @lead.email, @lead.company, 
                           @lead.job_title, @lead.phone, @lead.website)
    end
end
