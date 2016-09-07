require 'discordrb'
require 'configatron'
require 'yaml'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, application_id: configatron.appid, prefix: '!'
@raid_details = YAML::load_file('raid_list.yaml')
@raid_list = {}

bot.command(:stick, chain_usable: false) do |event|
  event.response "https://cdn.discordapp.com/attachments/190607069093691393/222907225809747968/a_fucking_stick_lamo.png"
end

bot.command(:make_raid, chain_usable: false) do |event, raid_name|
  if (@raid_details.key?(raid_name))
    raid_signup = RaidSignup.new(raid_name)

    if (@raid_list.size === 15)
      @raid_list.shift
    end

    raid_signup.load_roles(@raid_details[raid_name]['roles'])
    raid_id = Utilities.generate_id(raid_name)
    @raid_list[raid_id] = raid_signup
    event.response "Raid id: #{raid_id}, roles missing: #{raid_signup.roles_missing}"
  else
    event.response "This raid doesn't exist, bwaka."
  end
end

bot.command(:join_raid, chain_usable: false) do |event, raid_id, role|
  role = role.split.join
  @raid_list.each do |key, value|
  end
end

bot.run :async
