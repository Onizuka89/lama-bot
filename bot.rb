require 'rubygems'
require 'bundler/setup'
require 'config_file_loader'
require 'em-irc'
require 'logger'
$start_time = Time.now.to_i

if ConfigFileLoader.env.nil?
	ConfigFileLoader.env = 'development'
end

config = ConfigFileLoader.load('./lama-bot.yml')

if config.nil?
	puts "Error loading config file"
	exit
end
unless config[:host]
	puts "No host to connect"
	exit
end

######

lama = EventMachine::IRC::Client.new do
	host config[:host]
	port config[:port] || '6667'
	
	on :connect do
		nick(config[:nick])
		EM.add_timer(2) do
			join config[:channel]
		end
	end

	on :nick do
		EM.add_timer(2) do
			join config[:channel]
		end
	end
	
	on :join do |c|
		EM.add_timer(2) do
			#calls everytime someone join
			#Say hello?
		end
	end
	
	on :message do |source, target, msg|
		puts "#{Time.now} <#{source}> -> <#{target}> : #{msg}"
		# TODO move to events model and use matches
		if msg == "#{config[:nick]}, are you here"
			message target, "yes, I'm here, #{source}"
		end
		if msg == "hi #{config[:nick]}"
			message target, config[:welcome_message]
		end
	end
end

lama.run!
