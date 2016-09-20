require 'json'
#IMG_DIR = File.join(__dir__, 'raid_list.yml')

class CustomCommand
  def initialize(*args)
    @trigger = args[:trigger]
    @collection = args[:collection]
    @type = args[:type]
    @link = args[:link]
    file = File.read('./commands/commands.json')
    @commands_list = JSON.parse(file)
  end

  def command_exists?(trigger)
    @commands_list.has_key?(trigger)
  end

  def add_to_collection

  end

  def add_command
    command = {
      "#{@trigger}": {
        "type": @type,
        "link": @link
      }
    }
  end
end
