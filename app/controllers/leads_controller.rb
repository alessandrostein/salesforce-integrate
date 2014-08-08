require 'rd_person'

class LeadsController < ApplicationController
  extend Resque::Plugins::Heroku
  
  before_action :set_lead, only: [:show, :edit, :update, :destroy]

  def self.perform
    config_rd_person
    set_lead_rd_person
    @client.create(@people)
  end

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

    LeadsController.self.perform

    respond_to do |format|
      begin
        #if @client.create(@people)
        if Resque.enqueue(LeadsController)
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
        format.html { render :new, notice: 'Error the connect SalesforceClient' }
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
      @salesforce_username = ENV["SALESFORCE_USERNAME"]
      @salesforce_password =  ENV["SALESFORCE_PASSWORD"]
      @salesforce_security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
      @salesforce_client_id = ENV["SALESFORCE_CLIENT_ID"] 
      @salesforce_client_secret = ENV["SALESFORCE_CLIENT_SECRET"]

      puts 'Variaveis de ambiente'
      puts 'SALESFORCE_USERNAME: #{@salesforce_username}'
      puts 'SALESFORCE_PASSWORD: #{@salesforce_password}'
      puts 'SALESFORCE_SECURITY_TOKEN: #{@salesforce_security_token}'
      puts 'SALESFORCE_CLIENT_ID: #{@salesforce_client_id}'
      puts 'SALESFORCE_CLIENT_SECRET: #{@salesforce_client_secret}'
  
      @client = SalesforceClient.new(@salesforce_username, @salesforce_password, @salesforce_security_token,
                                     @salesforce_client_id, @salesforce_client_secret)
    end

    def set_lead_rd_person
      @people = Person.new(@lead.name, @lead.last_name, @lead.email, @lead.company, 
                           @lead.job_title, @lead.phone, @lead.website)
    end   
end
