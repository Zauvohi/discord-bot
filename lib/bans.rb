require 'json'

class Bans

  def initialize
    @ban_list = self.load_json
  end

  def self.load_json
    ban_list_path = "#{__dir__}/ban_list.json"

    unless File.exists?(ban_list_file)
      File.open(ban_list_path, 'w') { |f| f << "{\n\n}" }
    end

    file = File.read(File.join("#{__dir__}", 'ban_list.json'))
    JSON.parse(file)
  end

  def new_user?(user_id)
    !@ban_list.has_key?(user_id)
  end

  def user_banned?(user_id)
    @ban_list.has_key?(user_id)
  end

  def add(user_id, level)
    msg = ''

    if new_user?(user_id)
      msg = 'Use added.'
    else
      msg = 'Permissions updated.'
    end

    @ban_list[user_id] = level
    generate_json
    msg
  end

  def delete(user_id)
    msg = ""

    if new_user?(user_id)
      msg = "This user doesn't exits."
    else
      @ban_list.delete(user_id)
      msg = "User removed from list."
    end

    generate_json
    msg
  end

  private

  def generate_json
    File.open(File.join(__dir__, 'ban_list.json'), 'w') do |f|
      f.write(JSON.pretty_generate(@ban_list))
    end
  end
end
