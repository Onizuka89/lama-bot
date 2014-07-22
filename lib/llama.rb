require 'llama/behavers'
module Llama
	extend self
	@llama_behavers = Llama::Behavers.new

	def client= cli
		@client = cli
	end

	def nick= nck
		@nick = nck
	end

	def nick
		@nick || 'Llama'
	end

	def address_me? msg
		msg =~ /^#{nick}/i
	end

	def get_reaction msg
		return nil unless address_me? msg
		@llama_behavers.get_reaction msg	
	end

	def say_to target, msg
		@client.privmsg target, msg if @client		
	end
	
	def active_target
		@active_target
	end

	def active_target= trg
		@active_target = trg
	end
end
