require_relative "./fortune"
module CommonBehaver
	def self.included base
		base.class_eval do
			reaction :fortune do
				#f = `fortune`
                f = Fortunes.gen()
				f.each_line {|s| say s, :to=>active_channel}
			end
			react_on /say something good/i, :fortune
			react_on /I need fortune cookie/i, :fortune
            react_on /say something bad something bad/i, :fortune
            react_on /predict my future/i, :fortune
		end
	end
end
