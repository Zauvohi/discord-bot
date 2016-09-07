require 'discordrb'
require 'configatron'
require 'yaml'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, application_id: configatron.appid, prefix: '!'
raid_list = YAML::load_file('raid_list.yaml')

bot.command(:stick, chain_usable: false) do |event|
  event.channel.send_file File.new('../pics/afuckingsticklamo.png')
end

bot.run :async
