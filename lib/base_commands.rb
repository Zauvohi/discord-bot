module BaseCommands
  extend Discordrb::Commands::CommandContainer
  require 'net/http'
  require 'tempfile'
  require 'uri'
  require 'dotenv'
  Dotenv.load

  command(:add_command,
          chain_usable: true,
          description: "Adds or updates a custom command. Usage: !add_command trigger type url. Example: !add_command stick img url_to_picture. Please keep it clean and SFW."
          ) do |event, *args|

    trigger = args[0]
    type = args[1]
    content = args[2..args.size - 1].join(" ")

    if args.size >= 3
      command = CustomCommandGenerator.new(trigger, type, content, event.user.name)
      message = command.add
      new_commands = CustomCommandGenerator.load_commands(CustomCommands)
      bot.include! new_commands
      event.respond "#{message}"
    else
      event.respond "Missing arguments. Check !help add_command for more info."
    end
  end

  command(:update_command,
          chain_usable: false,
          description: "Updates a command. Usage: Same way you'd use add_command") do |event, *args|

    bot.execute_command(:add_command, event, args, chained: true)
  end

  command(:delete_command,
          chain_usable: false,
          description: "Deletes a command. Usage: !delete_command trigger_to_be_deleted") do |event, trigger|

    command = CustomCommandGenerator.new(trigger, "", "", event.user.name)
    message = command.delete
    updated_commands = CustomCommandGenerator.load_commands(CustomCommands)
    bot.include! updated_commands
    bot.remove_command(trigger.to_sym)
    event.respond "#{message}"
  end

  command(:list_contents,
          chain_usable: false,
          description: "Lists a command's contents (URLs)") do |event, trigger|

    command = CustomCommandGenerator.new(trigger, "", "", "")
    message = "These are #{trigger} contents: \n"

    command.list_contents.each_with_index do |item, index|
      message << "#{index} - <#{item}> \n"
    end

    event.user.pm(message)
  end

  command(:remove_item,
          chain_usable: false,
          description: "Deletes an item from a command. Usage: !remove_item command position") do |event, *args|

    trigger = args[0]
    position = args[1]
    command = CustomCommandGenerator.new(trigger, "", "", "")

    message = command.remove_item(position)

    updated_commands = CustomCommandGenerator.load_commands(CustomCommands)
    bot.include! updated_commands

    event.respond "#{message}"
  end

  command(:backup_commands, chain_usable: false) do |event|
    data = CustomCommandGenerator.get_json_contents
    file =  File.open("backup.json", "w") { |f| f << data }

    event.user.send_file(File.open(file, "r"))
    File.delete(file)
    nil
  end

  command(:change_avatar,
          chain_usable: false,
          description: "Changes the bot's avatar.") do |event, url|

    user_id = event.author.discriminator
    return nil if user_id != ENV['ADMINID']
    url = url.gsub(/\s+/, "")
    uri = URI.parse("#{url}")
    response = Net::HTTP.get_response(uri)
    file = Tempfile.new(["avatar", ".jpg"], Dir.tmpdir)
    file.binmode
    file.write(response.body)
    file.flush

    event.bot.profile.avatar=(File.open(file, "r"))
    nil
  end

  command(:playing,
          chain_usable: false,
          description: "Changes the game the bot is playing.") do |event, *game|

    user_id = event.author.discriminator
    return nil if user_id != ENV['ADMINID']
    event.bot.game=(game.join(" "))
    nil
  end
end