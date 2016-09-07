require 'discordrb'
require 'configatron'
require 'yaml'
require_relative 'config'
require_relative 'lib/raid_signup'
require_relative 'lib/utilities'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, application_id: configatron.appid, prefix: '!'

@raid_details = YAML::load_file('lib/raid_list.yml')
@raid_list = {}
LIST_MAX_LENGHT = 2

bot.command(:stick, chain_usable: false) do |event|
  event.respond "https://cdn.discordapp.com/attachments/190607069093691393/222907225809747968/a_fucking_stick_lamo.png"
end

bot.command(:otsu, chain_usable: false) do |event|
  event.respond "https://cdn.discordapp.com/attachments/222920939598381060/223097379279208449/8KzSio.png"
end

bot.command(:idolsheet, chain_usable: false) do |event|
  event.respond configatron.links.spreadsheet
end

bot.command(:make_raid, chain_usable: false) do |event, raid_name|
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

bot.command(:join_raid, chain_usable: false) do |event, raid_id, role|
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
bot.command(:leave_raid, chain_usable: false) do |event, raid_id|
  raid_id = raid_id.upcase
  raid = @raid_list[raid_id]
  raid.unassign(event.user.name)
  event.respond "#{event.user.name} left #{raid.name}."
end

bot.command(:checkraid, chain_usable: false) do |event, raid_id|
  raid_id = raid_id.upcase
  raid = @raid_list[raid_id]
  event << "Raid: #{raid.name}"
  event << "Members joined: #{raid.users_signed}"
  event << "Roles missing: #{raid.roles_missing}"
end

bot.run
