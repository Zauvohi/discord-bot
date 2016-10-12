module RaidCommands
  extend Discordrb::Commands::CommandContainer
  require 'yaml'
  require_relative 'raid_signup'
  require_relative 'utilities'

  LIST_MAX_LENGHT = 2
  @raid_details = YAML::load_file(File.join(__dir__, 'raid_list.yml'))
  @raid_list = {}
  @error_message = "My tummy hurts ;_;"

  command(:create, chain_usable: false) do |event, *args|
    begin
      raid_name = Utilities.underscore(args)

      unless @raid_details.has_key?(raid_name)
        @raid_details.each do |k, v|
          aliases = v['aliases'].respond_to?(:split) ? v['aliases'].split : []
          if aliases.include?(raid_name)
            raid_name = k
          end
        end
      end

      if (@raid_details.has_key?(raid_name))
        raid_signup = RaidSignup.new(raid_name, event.user.name)

        if (@raid_list.size === LIST_MAX_LENGHT)
          @raid_list.shift
        end

        raid_signup.load_roles(@raid_details[raid_name]['roles'])
        @raid_list[raid_name] = raid_signup
        event.respond "Raid: #{raid_signup.name}, roles suggested: #{raid_signup.suggested_roles}"
      else
        event.respond "This raid doesn't exist, bwaka."
      end
    rescue
      if (args === [])
        "Missing arugments. Usage !create [raid_name]"
      else
        @error_message
      end
    end
  end

  command(:join, chain_usable: false) do |event, *args|
    begin
      role = args.pop.upcase
      raid_name = Utilities.underscore(args)
      user = event.user.name
      raid = @raid_list[raid_name]
      if (raid.is_full?)
        event.respond "Raid is full."
      elsif (raid.add(user, role))
        event.respond "User #{user} joined #{raid.name} as #{role}"
      else
        event.respond "#{user} you're already in this raid."
      end
    rescue
      if (args.size < 2)
        "Missing arguments. Usage: !join [raid_name] role(ex_skill) (eg. !join rose queen df(ar3))"
      else
        @error_message
      end
    end

  end
  command(:leave, chain_usable: false) do |event, *args|
    begin
      raid_name = Utilities.underscore(args)
      raid = @raid_list[raid_name]
      if (raid.unassign(event.user.name))
        event.respond "#{event.user.name} left #{raid.name}."
      else
        event.respond "? You aren't even in that raid, bwaka!"
      end
    rescue
      if (args === [])
        "Missing arguments. Usage !leave [raid_name]. Example: !leave rose queen"
      else
        @error_message
      end
    end
  end

  command(:check, chain_usable: false) do |event, *args|
    begin
      if (args === [])
        @raid_list.each do |name, raid|
          event << "Raid: #{raid.name} - Joined: #{raid.users_joined}/#{raid.raid_size}"
        end
        nil
      else
        raid_name = Utilities.underscore(args)
        raid = @raid_list[raid_name]
        event << "Raid: #{raid.name} (#{raid.users_joined}/#{raid.raid_size})"
        event << "Members joined: #{raid.users_signed}"
        event << "Roles suggested: #{raid.suggested_roles}"
      end
    rescue
      @error_message
    end
  end

  command(:finish, chain_usable: false) do |event|
    @raid_list.each do |name, raid|
      if (raid.creator === event.user.name)
        @raid_list.delete(name)
        event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223097379279208449/8KzSio.png"
      end
    end
    nil
  end
end
