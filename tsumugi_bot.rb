require 'discordrb'
require 'dotenv'
require_relative './lib/raid_commands'
require_relative './lib/messages'
require_relative './lib/custom_commands_generator'
require_relative './lib/custom_commands'
require_relative './lib/waifu_rating'
Dotenv.load

bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], client_id: ENV['APPID'], prefix: '!'
bot.include! RaidCommands
bot.include! Messages
bot.include! WaifuRating

custom_commands = CustomCommandGenerator.load_commands(CustomCommands)
bot.include! custom_commands

bot.command(:add_command,
            chain_usable: true,
            description: "Adds or updates a custom command. Usage: !add_command trigger type url. Example: !add_command stick img url_to_picture. Please keep it clean and SFW."
            ) do |event, *args|

  trigger = args[0]
  type = args[1]
  url = args[2]

  unless args.size != 3
    command = CustomCommandGenerator.new(trigger, type, url, event.user.name)
    message = command.add
    new_commands = CustomCommandGenerator.load_commands(CustomCommands)
    bot.include! new_commands
    event.respond "#{message}"
  else
    event.respond "Missing arguments. Check !help add_command for more info."
  end
end

bot.command(:update_command,
            chain_usable: false,
            description: "Updates a command. Usage: Same way you'd use add_command") do |event, *args|

  bot.execute_command(:add_command, event, args, chained: true)
end

bot.command(:delete_command,
            chain_usable: false,
            description: "Deletes a command. Usage: !delete_command trigger_to_be_deleted") do |event, trigger|

  command = CustomCommandGenerator.new(trigger, "", "", event.user.name)
  message = command.delete
  updated_commands = CustomCommandGenerator.load_commands(CustomCommands)
  bot.include! updated_commands
  bot.remove_command(trigger.to_sym)
  event.respond "#{message}"
end

bot.run
