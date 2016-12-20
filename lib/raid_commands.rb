module RaidCommands
  extend Discordrb::Commands::CommandContainer
  require 'yaml'
  require_relative 'raid_signup'
  require_relative 'utilities'

  LIST_MAX_LENGHT = 10
  @raid_details = YAML::load_file(File.join(__dir__, 'raid_list.yml'))
  @raid_list = {}
  @error_message = "My tummy hurts ;_;"

  @raid_details.each do |k, v|
    aliases = v['aliases'].respond_to?(:split) ? v['aliases'].split : []
    @raid_details[k]['aliases'] = aliases
  end

  command(:create, chain_usable: false) do |event, *args|
    begin
      name = Utilities.underscore(args)
      raid_name = Utilities.find_raid_name(name, @raid_details)
      code = Utilities.generate_code(3)

      if (@raid_details.has_key?(raid_name))
        raid_signup = RaidSignup.new(raid_name, event.user.name)

        if (@raid_list.size === LIST_MAX_LENGHT)
          @raid_list.shift
        end

        raid_signup.load_roles(@raid_details[raid_name]['roles'])
        @raid_list[code] = raid_signup
        event << "Raid: #{raid_signup.name} - #{code}"
        event << "Roles:"
        raid_signup.suggested_roles.each do |role|
          event << role
        end
        nil
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
      code = args.pop.upcase
      user = event.user.name

      raid = @raid_list[code]

      event.respond "Raid is full." if raid.is_full?
      unless raid.add(user, role)
        event.respond "#{user} you're already in this raid."
      end
    rescue
      if (args.size < 2)
        "Missing arguments. Usage: !join [code] role(ex_skill) (eg. !join rose queen df(ar3))"
      else
        @error_message
      end
    end
  end

  command(:leave, chain_usable: false) do |event, *args|
    begin
      name = Utilities.underscore(args)
      raid_name = Utilities.find_raid_name(name, @raid_details)
      raid = @raid_list[raid_name]

      unless raid.unassign(event.user.name)
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
        @raid_list.each do |code, raid|
          event << "Raid: #{raid.name} (#{code}) - Joined: #{raid.users_joined}/#{raid.raid_size}"
        end
        nil
      else
        code = args.pop.upcase
        raid = @raid_list[code]
        event << "Raid: #{raid.name} by #{raid.creator} (#{raid.users_joined}/#{raid.raid_size})"
        event << "Members joined:"
        raid.users_signed.each do |user|
          event << user
        end
        nil
      end
    rescue
      @error_message
    end
  end

  command(:finish, chain_usable: false) do |event|
    @raid_list.each do |name, raid|
      if (raid.creator === event.user.name)
        @raid_list.delete(name)
        event.respond "https://my.mixtape.moe/tuoksd.png"
      end
    end
    nil
  end
end
