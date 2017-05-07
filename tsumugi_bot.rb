require 'discordrb'
require 'dotenv'
require 'pry'
require_relative './lib/base_commands'
require_relative './lib/messages'
require_relative './lib/custom_commands_generator'
require_relative './lib/custom_commands'
require_relative './lib/waifu_rating'
require_relative './lib/custom_roles'
require_relative './lib/gw_scores_commands'
require_relative './lib/anime_commands'
Dotenv.load

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['APPID'], prefix: '!'

bot.include! BaseCommands
bot.include! Messages
bot.include! WaifuRating
bot.include! CustomRoles
bot.include! GWScoresCommands
bot.include! AnimeCommands

custom_commands = CustomCommandGenerator.load_commands(CustomCommands)
bot.include! custom_commands

#binding.pry
bot.run
