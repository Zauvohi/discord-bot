module RaidCommands
  extend Discordrb::Commands::CommandContainer
  require 'yaml'
  require_relative 'raid_signup'
  require_relative 'utilities'

  LIST_MAX_LENGHT = 2
  @raid_details = YAML::load_file(File.join(__dir__, 'raid_list.yml'))
  @raid_list = {}

  command(:make_raid, chain_usable: false) do |event, raid_name|
    if (@raid_details.key?(raid_name))
      raid_signup = RaidSignup.new(raid_name)

      if (@raid_list.size === LIST_MAX_LENGHT)
        @raid_list.shift
      end

      raid_signup.load_roles(@raid_details[raid_name]['roles'])
      raid_id = Utilities.generate_id(raid_name)
      @raid_list[raid_id] = raid_signup
      event.respond "Raid id: #{raid_id}, roles missing: #{raid_signup.roles_missing}"
    else
      event.respond "This raid doesn't exist, bwaka."
    end
  end

  command(:join_raid, chain_usable: false) do |event, raid_id, role|
    role = role.downcase.split.join
    raid_id = raid_id.upcase
    user = event.user.name
    raid = @raid_list[raid_id]
    if (raid.assign(user, role))
      event.respond "User #{user} joined #{raid.name} as #{role}"
    else
      event.respond "#{user} you're already in this raid."
    end

  end
  command(:leave_raid, chain_usable: false) do |event, raid_id|
    raid_id = raid_id.upcase
    raid = @raid_list[raid_id]
    raid.unassign(event.user.name)
    event.respond "#{event.user.name} left #{raid.name}."
  end

  command(:checkraid, chain_usable: false) do |event, raid_id|
    raid_id = raid_id.upcase
    raid = @raid_list[raid_id]
    event << "Raid: #{raid.name}"
    event << "Members joined: #{raid.users_signed}"
    event << "Roles missing: #{raid.roles_missing}"
  end

end
