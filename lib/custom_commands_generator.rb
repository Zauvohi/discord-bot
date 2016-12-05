require 'json'
require_relative 'utilities'

class CustomCommandGenerator
  DIR_LOCATION = "#{__dir__}/commands/"

  def initialize(trigger, type, url, user)
    @trigger = trigger
    @type = type
    @url = url
    @commands_list = CustomCommandGenerator.load_json
    @user = user
  end

  def log_command(action)
    log_path = DIR_LOCATION + 'log.txt'

    unless File.exists?(log_path)
      File.open(log_path, 'w') { |f| f << "logger:" }
    end

    File.open(log_path, 'w') do |f|
      f << "User: #{@user} #{action}ed #{@trigger} (type: #{@type}, url: #{@url})"
    end
  end

  def self.load_json
    commands_path = DIR_LOCATION + 'commands.json'

    unless File.exists?(commands_path)
      File.open(commands_path, 'w') { |f| f << "{\n\n}" }
    end

    file = File.read(File.join(DIR_LOCATION, 'commands.json'))
    JSON.parse(file)
  end

  def self.load_commands(container)
    commands = CustomCommandGenerator.load_json
    commands.each do |command, params|
      container.command(command.to_sym, chain_usable: false) do |event|
        event.respond Utilities.random_element(params["urls"])
      end
    end
    container
  end

  def new_command?(trigger)
    !@commands_list.has_key?(trigger)
  end

  def new_url?(command, url)
    !@commands_list[command]["urls"].include?(url)
  end

  def save_command(command)
    @commands_list[@trigger] = command
    generate_json
    log_command("add")
  end

  def delete_command(command)
    @commands_list.delete(command)
    File.open(File.join(__dir__, '/commands/commands.json'), 'w') do |f|
      f.write(JSON.pretty_generate(@commands_list))
    end
    log_command("delet")
  end

  def add
    msg = "command #{@trigger} was "

    if new_command?(@trigger)
      command = {
        "type": @type,
        "urls": [@url]
      }
      save_command(command)
      msg << "added"
    elsif new_url?(@trigger, @url)
      command = @commands_list[@trigger]
      command["urls"].push(@url)
      save_command(command)
      msg << "updated"
    else
      msg = "This url was already added."
    end
    msg
  end

  def delete
    msg = "command #{@trigger} was deleted"

    if new_command?(@trigger)
      msg = "this command doesn't exist."
    else
      delete_command(@trigger)
    end
    msg
  end

  def list_contents
    @commands_list[@trigger]["urls"] unless new_command?(@trigger)
  end

  def remove_item(position)
    msg = ""

    if new_command?(@trigger)
      msg = "This command does not exist"
    else
      deleted = @commands_list[@trigger]["urls"].slice!(position.to_i)
      generate_json
      msg = "Item in the position [ #{position} ] from *#{@trigger}* was deleted (it was <#{deleted}>)"
    end

    msg
  end

  private

  def generate_json
    File.open(File.join(__dir__, '/commands/commands.json'), 'w') do |f|
      f.write(JSON.pretty_generate(@commands_list))
    end
  end
end
