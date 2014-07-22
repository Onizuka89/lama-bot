require 'rubygems'
require 'bundler/setup'
require 'config_file_loader'
require 'em-irc'
require 'logger'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),'lib'))
require 'llama'
$start_time = Time.now.to_i

ConfigFileLoader.env = "production" if ARGV[0] == "production"

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

log_file = config[:message_file] || 'messages.txt'
message_logger = File.new("#{log_file}.#{Time.now.to_i}", 'a')
######
Llama.nick = config[:nick]

llama = EventMachine::IRC::Client.new do
	host config[:host]
	port config[:port] || '6667'
	Llama.client = self
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
		message_logger.puts "#{Time.now} <#{source}> -> <#{target}> : #{msg}"
		Llama.active_target= target
		Llama.get_reaction msg
	end
	on :disconnect do
		message_logger.close
	end
end

llama.run!
