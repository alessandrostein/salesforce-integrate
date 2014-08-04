require 'rd_person'

class LeadsController < ApplicationController

	def index
		@lead = Lead.index
	end

	def show
		
	end

	def new
		@lead = 'new'
	end

	def create
	
		@lead = lead_params
	
		respond_to do |format|
			format.html {render "index"}
			format.xml {render xml: @lead}
		end
	end

	def lead_params
      	params.require(:lead).permit(:name, :last_name, :email, :company, :job_title, :phone, :website)
    end

end
