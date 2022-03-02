require 'discordrb'
require 'dotenv'
require_relative './lib/base_commands'
require_relative './lib/messages'
require_relative './lib/custom_commands_generator'
require_relative './lib/custom_commands'
require_relative './lib/waifu_rating'
require_relative './lib/custom_roles'
require_relative './lib/gw_scores_commands'
require_relative './lib/anime_commands'
require_relative './lib/anime_scheduler'
# require_relative './db/config'
Dotenv.load

class Discordrb::Commands::CommandBot
  attr_accessor :anime_scheduler
end

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['APPID'], prefix: '!'

bot.include! BaseCommands
bot.include! Messages
bot.include! WaifuRating
bot.include! CustomRoles
bot.include! GWScoresCommands
# bot.include! AnimeCommands

custom_commands = CustomCommandGenerator.load_commands(CustomCommands)
bot.include! custom_commands

# DB Stuff
# DB_CONTAINER = ROM.container(ROMCOnfig.config)

# bot.run :async
# anime_scheduler = AnimeScheduler.new
# anime_scheduler.add_bot(bot)
# role = bot.servers[ENV['MAIN_SERVER'].to_i].roles.find { |r| r.name == "anime" }
# anime_scheduler.add_role(role)
# anime_scheduler.schedule
# bot.anime_scheduler = anime_scheduler

bot.run
