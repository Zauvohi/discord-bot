require 'discordrb'
require 'dotenv'
require_relative './lib/picture_commands'
require_relative './lib/raid_commands'
require_relative './lib/messages'
Dotenv.load

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], application_id: ENV['APPID'], prefix: '!'
bot.include! PictureCommands
bot.include! RaidCommands
bot.include! Messages

bot.command(:idolsheet, chain_usable: false) do |event|
  event.respond "https://docs.google.com/spreadsheets/d/13xphGFupxzXDW0Y4L0-4Da60buzetWfW_v5lonwZWG0/edit#gid=0"
end

bot.command(:superspecial, chain_usable: false) do |event|
  event.respond "https://www.youtube.com/watch?v=TUmm1QjLC5U"
end

bot.run
