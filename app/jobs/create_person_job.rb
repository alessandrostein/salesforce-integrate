require 'rd_person'

class CreatePersonJob
	@queue	= :createpeople

	def self.perform(client, lead)
		client.create(lead)
	end
end
