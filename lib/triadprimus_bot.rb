require 'discordrb'
require 'configatron'
require 'yaml'

bot = Discordrb::Commands::CommandBot.new token: configatron.token, application_id: configatron.appid, prefix: '!'
@raid_details = YAML::load_file('raid_list.yaml')
@raid_list = []

bot.command(:stick, chain_usable: false) do |event|
  event.channel.send_file File.new('../pics/afuckingsticklamo.png')
end

bot.command(:make_raid, chain_usable: false) do |event, raid_name|
  if (@raid_details.key?(raid_name))
    raid_signup = RaidSignup.new(raid_name)

    if (@raid_list.size === 15)
      @raid_list.pop
    end

    raid_signup.load_roles(@raid_list[raid_name]['roles'])
    raid_id = Utilities.generate_id(raid_name)
    raid = { raid_id: raid_id, raid: raid_signup }
    @raid_list.push(raid)
    event.response "Raid id: #{raid_id}, roles missing: #{raid_signup.roles_missing}"
  else
    event.response "This raid doesn't exist, bwaka."
  end
end

bot.run :async
