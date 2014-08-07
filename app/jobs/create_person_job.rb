require 'rd_person'

class CreatePersonJob
	extend Resque::Plugins::Heroku

	def self.perform(@lead)
		config_rd_person
		set_lead_rd_person(@lead)
		@client.create(@people)
	end

	
end
