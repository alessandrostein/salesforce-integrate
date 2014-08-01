require 'rd_person'

class RdPersonController < ApplicationController

	def show
		@rd_person = rd_person.find(params[:id])
	end

	def new
		render 'new'
	end	

	def create
		render plain: params[:rd_person].inspect
	end

	def show
    	render 'new'
  end
end
