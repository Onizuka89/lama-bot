# reactions on Nixi
# Don't look at me. I just do it for fun. Why llama bot can't welcome
# our hero. 
module Nixie
	def self.included base
		base.class_eval do
			on_join /nixie/ do
	  			react :welcome_nixie
			end
	
			reaction :welcome_nixie do
				special_fortune = `fortune mylist`
				welcomes = [
					'Nixie love Llama, and Llama love Nixie',
					'Nixie, Nixie, Nixie. Hi!',
					'nixie: I love you <3',
					'Talk nerdy to me :-)',
					special_fortune
				]
				say welcomes.sample, :to => active_channel
				set_status 'in love'
			end

			reaction :good_bye_nixie do
				say [
					"Good bye, miss Nixie",
					"nixie: Don't leave Llama alone :'-("
				].sample, :to => active_channel
			end
			react_on /nixie here$/i, :welcome_nixie
			react_on /say hello$/i, :welcome_nixie

			react_on /say good bye/i, :good_bye_nixie
		end
	end
end
