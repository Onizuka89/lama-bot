module Llama
	class BehaverProvider
		class << self
			def on_join name, &blk
				on_join_events << {:pattern => name, :blk => blk}
			end


			def reaction r, &blk
				reactions[r] = blk
			end

			def set_status msg
				#ops?
			end
			
			def active_channel
				@active_channel
			end
			def active_channel= c
				@active_channel = c
			end
			
			def react_on pattern, reaction
				text_reactions << {:pattern => pattern, :reaction => reaction}
			end
			
			def on_join_events
				@on_join_events ||=[]
				@on_join_events
			end
			def reactions
				@reactions||={}
			end

			def text_reactions
				@text_reactions||=[]
			end

			def say msg, opts = {}
				return unless opts.has_key? :to
				Llama.say_to opts[:to], msg
			end

			def react reaction
				if reactions.has_key? reaction
					reactions[reaction].call
				end
			end
			
			def active_channel
				Llama.active_target
			end
			
			def get_reaction msg
				text_reactions.each do |tr|
					if msg =~ tr[:pattern]
						r = tr[:reaction]
						reactions[r].call if reactions.has_key? r
					end
				end
			end
		end

		def react reaction
			self.class.react reaction
		end


		def get_reaction msg
			self.class.get_reaction msg
		end
	end
end
