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
	puts config[:host]
	
	host config[:host]
	port config[:port] || '6667'
	
	on :connect do
		nick(config[:nick])
	end

	on :nick do
		EM.add_timer(2) do
			join config[:channel]
		end
	end
	
	on :join do |c|
		EM.add_timer(2) do
			message config[:channel], config[:welcome_message]
		end
	end
	
	on :message do |source, target, msg|
		puts source
		puts target
		if msg == 'lama, are you here'
			message target, "yes, I'm #{source}"
		end
		
	end
end

lama.run!
