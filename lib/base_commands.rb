module BaseCommands
  extend Discordrb::Commands::CommandContainer
  require 'net/http'
  require 'tempfile'
  require 'uri'
  require 'dotenv'
  require 'rufus-scheduler'
  require_relative 'news_scraper'
  require_relative 'bans'

  Dotenv.load

  bucket :news, limit: 3, time_span: 180, delay: 10
  @scheduler = Rufus::Scheduler.new
  @news_channels = []
  @ban_list = Bans.new

  command(:add_command,
          chain_usable: true,
          description: "Adds or updates a custom command. Usage: !add_command trigger type url. Example: !add_command stick img url_to_picture. Please keep it clean and SFW."
          ) do |event, *args|

    return nil if @ban_list.user_banned?(event.author.discriminator)
    return nil if @ban_list.user_banned?(event.author.discriminator)
    trigger = args[0]
    type = args[1]
    content = args[2..args.size - 1].join(" ")

    if args.size >= 3
      command = CustomCommandGenerator.new(trigger, type, content, event.user.name)
      message = command.add
      new_commands = CustomCommandGenerator.load_commands(CustomCommands)
      event.bot.include! new_commands
      event.respond "#{message}"
    else
      event.respond "Missing arguments. Check !help add_command for more info."
    end
  end

  command(:update_command,
          chain_usable: false,
          description: "Updates a command. Usage: Same way you'd use add_command") do |event, *args|

    return nil if @ban_list.user_banned?(event.author.discriminator)
    event.bot.execute_command(:add_command, event, args, chained: true)
  end

  command(:delete_command,
          chain_usable: false,
          description: "Deletes a command. Usage: !delete_command trigger_to_be_deleted") do |event, trigger|

    return nil if @ban_list.user_banned?(event.author.discriminator)
    bot = event.bot

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

    return nil if @ban_list.user_banned?(event.author.discriminator)
    trigger = args[0]
    position = args[1]
    command = CustomCommandGenerator.new(trigger, "", "", "")

    message = command.remove_item(position)

    updated_commands = CustomCommandGenerator.load_commands(CustomCommands)
    event.bot.include! updated_commands

    event.respond "#{message}"
  end

  command(:backup_commands, chain_usable: false) do |event|
    return nil if @ban_list.user_banned?(event.author.discriminator)
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

  command(:ban,
          chain_usable: false,
          description: "Bans an user from using the bots. Usage: !ban user_id, mode. It can be total or partial.") do |event, *args|

    return nil if event.author.discriminator != ENV['ADMINID']

    user_id = args[0].delete("#")
    level = args[1]
    @ban_list.add(user_id, level)
  end

  command(:remove_ban,
          chain_usable:false,
          description: "Removes a banned user from the list. Usage: !remove_ban user_id") do |event, *args|

    return nil if event.author.discriminator != ENV['ADMINID']

    user_id = args[0]
    @ban_list.delete(user_id)
  end

  command(:playing,
          chain_usable: false,
          description: "Changes the game the bot is playing.") do |event, *game|

    user_id = event.author.discriminator
    return nil if user_id != ENV['ADMINID']
    event.bot.game=(game.join(" "))
    nil
  end

  command(:news,
          chain_usable: false,
          bucket: :news,
          description: "Lastest news from the official website. Example: !news 5m 5h . This will lurk the news page every 5 minutes for 5 hours. If the time params are ommitted, it'll bring the lastests news from the site.") do |event, *args|

    return nil if @ban_list.user_banned?(event.author.discriminator)
    bot = event.bot
    channel_id = event.channel.id
    post = NewsScraper.new

    post.update

    if args.empty?
      event.respond "#{post.lastest}"
    elsif args.include?('subscribe')
      @news_channels.push(channel_id)
      event.respond "Channel subscribed for news."
    elsif args.include?('unsubscribe')
      @news_channels.slice!(@news_channels.index(channel_id))
      event.respond "Channel unsubscribed for news."
    elsif args.include?('cancel')
      current_job = @scheduler.jobs(tags: 'scraper')[0]
      @scheduler.unschedule(current_job)
      event.respond "News checker has been cancelled."
    else
      interval = args[0]
      stop_at = args[1] || "1h"

      if @scheduler.jobs(tag: 'scraper').size > 0
        scheduled_job = @scheduler.jobs(tags: 'scraper')[0]
        original_interval = scheduled_job.original
        original_stop_at = scheduled_job.opts[:last_in]
        seconds = scheduled_job.next_time.seconds
        next_time = Time.at(seconds).min - Time.now.min

        return event.respond %Q(
          There's a job already queued.
          Every: #{original_interval} For: #{original_stop_at}
          Next check in: #{next_time}m
        )
      else
        @news_channels.push(channel_id) unless @news_channels.include?(channel_id)
        bot.send_temporary_message(channel_id,"In queue, every: #{interval} for: #{stop_at}", 30)

        @scheduler.every "#{interval}", last_in: stop_at, tag: 'scraper' do |job|
          p = post.get_news

          if post.is_recent?(p)
            post.info = p
            job.unschedule
            @news_channels.each do |channel|
              bot.send_message(channel, post.lastest)
            end
          end
        end
      end

      nil
    end
  end
end
