require 'discordrb'
require 'dotenv'
require_relative './lib/base_commands'
require_relative './lib/messages'
require_relative './lib/custom_commands_generator'
require_relative './lib/custom_commands'
require_relative './lib/waifu_rating'
require_relative './lib/custom_roles'
Dotenv.load

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['APPID'], prefix: '!'

bot.include! BaseCommands
bot.include! Messages
bot.include! WaifuRating
bot.include! CustomRoles

custom_commands = CustomCommandGenerator.load_commands(CustomCommands)
bot.include! custom_commands

bot.run
