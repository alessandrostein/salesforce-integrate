require 'rd_person'

class CreatePersonJob
	extend Resque::Plugins::Heroku
	
	def self.perform(client, lead)
		client.create(lead)
	end
end
