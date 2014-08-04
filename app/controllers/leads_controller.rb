require 'rd_person'

class LeadsController < ApplicationController

	def index
		render = 'index'
	end

	def new
		render = 'new'
	end

	def create
		@name = params[:lead][:name]
		@last_name = params[:lead][:last_name]
		@email = params[:lead][:email]
		@company = params[:lead][:company]
		@job_title = params[:lead][:job_title]
		@phone = params[:lead][:phone]
		@website = params[:lead][:website]


	    @people = Person.new(@name, @last_name, @email, @company, @job_title, @phone, @website)

    	@client = SalesforceClient.new('', '', '',
                                  '',
                                  '')
    	@client.create(@people)

		respond_to do |format|
			format.html {render "index"}
			format.xml {render xml: @client}
		end
	end

end
