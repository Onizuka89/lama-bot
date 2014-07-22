module Llama
	require 'llama/behavers/nixie'
	require 'llama/behavers/common'
	require 'llama/behaver_provider'
	class Behavers < Llama::BehaverProvider
		include Nixie
		include CommonBehaver
	end
end 
